/**
 * Title: VisitProcess.java
 * Description:
 * Copyright: Copyright (c) 2018
 * Company: yz0515.cn
 * @author yangzheng
 * @date 2018年3月13日
 * @version 1.0
 */
package cn.yz0515.mr.visit;

import cn.yz0515.mr.bean.PageViewBean;
import cn.yz0515.mr.bean.VisitBean;
import cn.yz0515.mr.exception.ExceptionCode;
import cn.yz0515.mr.exception.ServiceRuntimeException;
import cn.yz0515.mr.parsers.WebLogBeanParser;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

import java.io.IOException;
import java.util.*;

/**
 * Title: VisitProcess
 * Description:	点击流模型visit表处理
 * @author yangzheng
 * @date 2018年3月13日
 */
public class VisitProcess {

    static class VisitMapper extends Mapper<LongWritable, Text, Text, PageViewBean> {
        private Text k = new Text();
        private PageViewBean v = new PageViewBean();
        @Override
        protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
            String line = value.toString();
            // 665dfb07-28a2-4f99-95c7-43bdec3a6da6101.226.167.201/hadoop-mahout-roadmap/2013-09-18 09:30:36160"http://blog.fens.me/hadoop-mahout-roadmap/"10335200"Mozilla/4.0(compatible;MSIE8.0;WindowsNT6.1;Trident/4.0;SLCC2;.NETCLR2.0.50727;.NETCLR3.5.30729;.NETCLR3.0.30729;MediaCenterPC6.0;MDDR;.NET4.0C;.NET4.0E;.NETCLR1.1.4322;TabletPC2.0);360Spider"
            String[] arr = line.split(WebLogBeanParser.SPLIT_DELIMITER);
            String session = arr[0];
            k.set(session);
            Integer step = Integer.parseInt(arr[4]);
            v.set(session, arr[1], arr[9], arr[3], arr[2], step, arr[5], arr[6], arr[7], arr[8]);
            context.write(k, v);
        }
    }

    static class VisitReducer extends Reducer<Text, PageViewBean, VisitBean, NullWritable> {
        @Override
        protected void reduce(Text key, Iterable<PageViewBean> values, Context context) throws IOException, InterruptedException {
            List<PageViewBean>  beans = new ArrayList<>();
            for (PageViewBean value : values) {
                PageViewBean bean = new PageViewBean();
                try {
                    BeanUtils.copyProperties(bean, value);
                } catch (Exception e) {
                    throw new ServiceRuntimeException(ExceptionCode.COMMON.BEAN_ATTR_COPY_EXCEPTION, "复制pageviewbean失败");
                }
                beans.add(bean);
            }

            // 根据时间进行排序
            beans.sort((PageViewBean o1, PageViewBean o2) -> {
                Date time1 = WebLogBeanParser.toDate(o1.getTimestr());
                Date time2 = WebLogBeanParser.toDate(o2.getTimestr());
                if (!Optional.ofNullable(time1).isPresent() || !Optional.ofNullable(time2).isPresent()) {
                    return 0;
                }
                return time1.compareTo(time2);
            });

            // 取这次visit的首尾pageview记录，将数据放入VisitBean中
            VisitBean visitBean = new VisitBean();
            // 进入页面
            PageViewBean in = beans.get(0);
            visitBean.setInPage(in.getRequest());
            visitBean.setInTime(in.getTimestr());
            // 离开页面
            PageViewBean out = beans.get(beans.size() - 1);
            visitBean.setOutPage(out.getRequest());
            visitBean.setOutTime(out.getTimestr());
            // 访问的总页面数
            visitBean.setPageVisits(beans.size());
            visitBean.setSession(in.getSession());
            visitBean.setReferal(in.getReferal());
            visitBean.setRemote_addr(in.getRemote_addr());

            context.write(visitBean, NullWritable.get());
        }
    }


    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf);

        job.setJarByClass(VisitProcess.class);

        job.setMapperClass(VisitMapper.class);
        job.setReducerClass(VisitReducer.class);

        job.setMapOutputKeyClass(Text.class);
        job.setMapOutputValueClass(PageViewBean.class);

        job.setOutputKeyClass(VisitBean.class);
        job.setOutputValueClass(NullWritable.class);

        Path output = new Path(args[1]);
        FileSystem fs = FileSystem.get(conf);
        if (fs.exists(output)) {
            fs.delete(output, true);
        }

        FileInputFormat.setInputPaths(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, output);

        //测试
        /*FileInputFormat.setInputPaths(job, new Path("hdfs://localhost:8020/web_click_project/pv_output"));
        FileOutputFormat.setOutputPath(job, new Path("hdfs://localhost:8020/web_click_project/visit_output"));*/

        boolean result = job.waitForCompletion(true);
        System.exit(result ? 0 : 1);
    }
}