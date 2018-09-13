# _*_ coding: utf-8 _*_

import random
import sys
from fake_useragent import UserAgent

"""
Desc: 本程序用于生成web访问日志
      日志完全按照apache日志的格式生成
Author: Zeno
Date: 2018-04-23
Email: cookie.yz@qq.com
"""

"""
pip install fake-useragent
https://github.com/yangzheng0515/fake-useragent
"""

def random_str(randomlength=8):
    str = ''
    chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789'
    length = len(chars) - 1
    for i in range(randomlength):
        str += chars[random.randint(0, length)]
    return str

class GenerateLog(object):

    def __init__(self):
        self.ips = open('./000000_0.ips').read().split('\n')
        # self.logfile = open('./access.log', mode='w')
        self.logfile = open(sys.argv[1], mode='w')
        self.ua = UserAgent()

        self.minutes = []
        for i in range(00, 40):
            t = i + random.randint(0, 19)
            self.minutes.append(str(t) if len(str(t)) > 1 else "0" + str(t))

        self.seconds = []
        for i in range(00, 40):
            t = i + random.randint(0, 19)
            self.seconds.append(str(t) if len(str(t)) > 1 else "0" + str(t))

        self.hours = []
        for i in range(00, 24):
            self.hours.append(str(i) if len(str(i)) > 1 else "0" + str(i))

        self.pages = ['/register', '/recommand', '/relation', '/item/a', '/item/b', '/item/c', '/list/', '/search/', '/cart',
                 '/order/getorder', '/order/submitorder', '/index', '/category/a', '/category/b', '/category/c',
                 '/category/d']
        for i in range(10):
            self.pages.append("/item/" + random_str(8))

        self.months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']

        self.refers = ['http://www.google.com', 'www.baidu.com', 'www.sohu.com', 'www.so.com', 'www.cn.bing.com', '-']

    def gengrate(self, num = 10000):
        for i in range(0, num):
            ip = random.choice(self.ips)
            hour = random.choice(self.hours)
            minute = random.choice(self.minutes)
            second = random.choice(self.minutes)
            day = random.choice(self.minutes)
            month = random.choice(self.months)
            year = '2018'

            time_local = '[{}/{}/{}:{}:{}:{} +0000]'.format(day, month, year, hour, minute, second)

            page = random.choice(self.pages)
            refer = random.choice(self.refers)
            body_sent = random.randint(0, 1800)
            status = random.choice(['200', '200', '200', '200', '200', '304', '404'])
            user = '-'

            data = '{} {} - {} "GET {} HTTP/1.1" {} {} "{}" "{}"'.format(ip, user, time_local, page, status, body_sent, refer, self.ua.random)
            self.logfile.write(data + '\n')
            # print(data)
        self.logfile.close()

if __name__ == '__main__':
    GenerateLog().gengrate(int(sys.argv[2]))
