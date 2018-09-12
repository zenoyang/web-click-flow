/**
 * Title: WeblogPreValid.java
 * Description:
 * Copyright: Copyright (c) 2018
 * Company: yz0515.cn
 * @author yangzheng
 * @date 2018年3月9日
 * @version 1.0
 */
package cn.yz0515.mr.pre;

import cn.yz0515.mr.bean.WebLogBean;
import cn.yz0515.mr.parsers.ValidUrlPrefixParser;
import cn.yz0515.mr.parsers.WebLogBeanParser;
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
import java.util.Collection;
import java.util.HashSet;
import java.util.Optional;

/**
 * 备份错误日志
 */
public class WeblogPreValid {
    static class WeblogPreValidMapper extends Mapper<LongWritable, Text, Text, WebLogBean> {
        Collection<String> valids = new HashSet<>();
        Text k = new Text();

        @Override
        protected void setup(Context context) throws IOException, InterruptedException {
            valids = ValidUrlPrefixParser.parse();
        }

        @Override
        protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
            String line = value.toString();
            WebLogBean bean = WebLogBeanParser.parse(line);

            if (!Optional.ofNullable(bean).isPresent()) {
                return;
            }

            // 过滤js/css/图片等静态资源文件
            // WebLogBeanParser.filtStaticResource(bean, valids);
            if (bean.isValid()) {
                k.set(bean.getRemote_addr());
                context.write(k, bean);
            }
        }
    }

    static class WeblogPreValidReducer extends Reducer<Text, WebLogBean, NullWritable, WebLogBean> {

        @Override
        protected void reduce(Text key, Iterable<WebLogBean> values, Context context) throws IOException, InterruptedException {
            for(WebLogBean bean:values){
                context.write(NullWritable.get(), bean);
            }
        }
    }


    public static void main(String[] args) throws Exception {

        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf);

        job.setJarByClass(WeblogPreValid.class);

        job.setMapperClass(WeblogPreValidMapper.class);
        job.setReducerClass(WeblogPreValidReducer.class);

        job.setMapOutputKeyClass(Text.class);
        job.setMapOutputValueClass(WebLogBean.class);

        job.setOutputKeyClass(NullWritable.class);
        job.setOutputValueClass(WebLogBean.class);

         Path output = new Path(args[1]);
        //输出目录不能存在，否则报错
        FileSystem fs = FileSystem.get(conf);
        if (fs.exists(output)) {
            fs.delete(output, true);
        }

        FileInputFormat.setInputPaths(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, output);

        // 测试
        /*FileInputFormat.setInputPaths(job, new Path("hdfs://localhost:8020/data/weblog/preprocess/input"));
        FileOutputFormat.setOutputPath(job, new Path("hdfs://localhost:8020/data/weblog/preprocess/valid_output"));*/

        boolean result = job.waitForCompletion(true);
        System.exit(result ? 0 : 1);
    }
}
