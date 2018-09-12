/**
 * Title: WebLogPreProcess.java
 * Description:
 * Copyright: Copyright (c) 2018
 * Company: yz0515.cn
 * @author yangzheng
 * @date 2018年3月9日
 * @version 1.0
 */
package cn.yz0515.mr.pre;

import java.io.IOException;
import java.util.Collection;
import java.util.HashSet;
import java.util.Optional;

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
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

/**
 * 日志预处理，清洗过滤
 */
public class WebLogPreProcess {

    static class WebLogPreProcessMapper extends Mapper<LongWritable, Text, WebLogBean, NullWritable> {
        Collection<String> valids = new HashSet<>();

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
            if (!bean.isValid()) {
                return;
            }

            context.write(bean, NullWritable.get());
        }
    }


    public static void main(String[] args) throws Exception {

        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf);

        job.setJarByClass(WebLogPreProcess.class);
        job.setMapperClass(WebLogPreProcessMapper.class);
        job.setOutputKeyClass(WebLogBean.class);
        job.setOutputValueClass(NullWritable.class);

        job.setNumReduceTasks(0);

        Path output = new Path(args[1]);
        // 输出目录不能存在，否则报错
        FileSystem fs = FileSystem.get(conf);
        if (fs.exists(output)) {
            fs.delete(output, true);
        }

        FileInputFormat.setInputPaths(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, output);

        // 测试
        /*FileInputFormat.setInputPaths(job, new Path("file:///home/yz/桌面/Hive-WebLogProcess/GenerateApacheLog/input"));
        FileOutputFormat.setOutputPath(job, new Path("file:///home/yz/桌面/Hive-WebLogProcess/GenerateApacheLog/preoutput"));*/

        boolean result = job.waitForCompletion(true);
        System.exit(result ? 0 : 1);
    }
}
