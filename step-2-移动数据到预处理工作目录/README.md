## 移动数据到预处理的工作目录

数据源: `/data/flumedata/%y-%m-%d/`  
目标路径: `/data/weblog/preprocess/input`  

or (省略Flume步骤)
```
yz@master:~/Desktop/Hive-WebLogProcess/GenerateApacheLog$ date -d'-1 day' +%Y-%m-%d
2018-03-10
yz@master:~/Desktop/Hive-WebLogProcess/GenerateApacheLog$ hadoop fs -mkdir -p /data/weblog/preprocess/input/2018-03-10
18/03/11 02:38:38 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
yz@master:~/Desktop/Hive-WebLogProcess/GenerateApacheLog$ hadoop fs -put ./access.log /data/weblog/preprocess/input/2018-03-10
18/03/11 02:38:59 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
```
