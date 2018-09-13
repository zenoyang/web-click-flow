## 模拟生成web访问日志

日志完全按照apache日志的格式生成  
生成的日志格式如下：  
```
101.226.168.204 - - [39/Feb/2018:11:46:42 +0000] "GET /item/c HTTP/1.1" 404 826 "http://www.google.com" "Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.14 (KHTML, like Gecko) Chrome/24.0.1292.0 Safari/537.14"
113.90.232.163 - - [30/Oct/2018:07:11:30 +0000] "GET /item/b HTTP/1.1" 304 1079 "www.sohu.com" "Mozilla/5.0 (X11; CrOS i686 4319.74.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.57 Safari/537.36"
42.156.137.46 - - [42/Mar/2018:09:46:17 +0000] "GET /cart HTTP/1.1" 200 115 "www.so.com" "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.93 Safari/537.36"
```

## 使用方法      
需要提前下载`fake-useragent`Python库：  
```
pip install fake-useragent
```

使用方法：  
```
python GenerateApacheLog.py log_path log_count
```

例如：  
```
python GenerateApacheLog.py ./access.log 10000
```
表示在当前目前下生成10000行访问记录，文件名为access.log的日志文件  
