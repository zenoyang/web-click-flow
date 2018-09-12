## Flume配置
用tail命令获取数据，下沉到hdfs 启动命令：
```
bin/flume-ng agent -c conf -f conf/tail-hdfs.conf -n a1
```

数据来源： `/home/yz/log/test.log`
上传到HDFS的目录： `/data/flumedata/%y-%m-%d/`
