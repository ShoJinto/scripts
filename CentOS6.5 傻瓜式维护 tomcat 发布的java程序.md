# CentOS6.5 傻瓜式维护 tomcat 发布的java程序

标签（空格分隔）： 未分类

---

## 说在前面
此文档的受众为没有任何linux基础的人员，大神勿喷。

### 预备工作
准备linux远程登陆客户端[Xshell](http://download.softpedia.com/dl/5056da578c8a5f3c770f71da7a68e90e/5799681b/100187987/software/network/Xshell5.exe)和远程登陆服务器的密钥，看到这篇文章的时候可以单独联系我进行获取。

- 下载`Xshell`
点击如下链接进行`Xshell`[下载](http://download.softpedia.com/dl/5056da578c8a5f3c770f71da7a68e90e/5799681b/100187987/software/network/Xshell5.exe)
- 安装`Xshell`
1. 双击前面下载的`Xshell5.exe`安装程序，等待安装程序初始化完毕然后`下一步`。
2. 选择`安装类型`的时候注意选择成`免费为家庭/学校`点击`下一步`。
3. `接受许可协议`然后继续`下一步`。
4. `安装目的位置`按照个人喜好进行选择即可，我喜欢默认就直接`下一步`了。
5. 继续`下一步`。
6. `选择语言`自然是`简体中文`然后`下一步`。
7. 等待安装完成勾选`启动Xshell`点击`完成`。
- 设置`Xshell`
1. 点击`新建`按钮弹出`新建会话属性`对话框按照图片上示意进行填写。
![Xshell启动界面][1]
![新建会话界面][2]
2. 选择`用户身份验证`按照图示进行填写即可，导入的`密钥`需要联系我这边获取。
![导入密钥界面][3]
3. 点击`确定`之后回到会话列表对话框，选中`qht_server`会话点击`连接`按钮进行连接，第一次连接进行`密钥`安全确认
![此处输入图片的描述][4]
![密钥确认][5]
4. 完成与服务器的连接之后的效果如下图：
![登陆服务器效果图][6]
### 程序维护
- 程序的基本情况

        程序分为mysql数据库和java程序两个部分。日常维护过程中牵涉到数据库的操作不是太多，所以不做过多阐述。有兴趣可以自己google相关信息进行学习，后面会说明在本应用中mysql维护的一些操作。

>java程序部署在`/usr/local/apache-tomcat-8.0.32/`,目录结构如下：
```
/usr/local/apache-tomcat-8.0.32/
├── bin
├── conf
├── lib
├── LICENSE
├── logs        日志所在位置
├── NOTICE
├── RELEASE-NOTES
├── RUNNING.txt
├── temp
├── webapps     war所在位置
└── work
```
>程序安装包所在位置以及简单介绍
```
/usr/local/apache-tomcat-8.0.32/webapps/
├── logs
├── ROOT
└── ROOT.war    更新程序的时候用开发给的war包覆盖
```
>程序日志所在位置以及简单介绍
```
/usr/local/apache-tomcat-8.0.32/logs/
├── ....
├── catalina.out    需要定位问题的时候请将此文件发给开发
├── ....
└── safeguard.log
```

- 实操
`lrzsz`命令功能说明：这是一套组合命令，分为`sz`命令和`rz`命令。用于在linux和windows客户端之间进行数据传输，`rz`将windows上的文件传输到linux服务器上；`sz`将linux上的文件传输到windows上。

>先来体验一把！

在linux终端上输入`rz`命令，将调出一个对话框，和一般的网页上传控件功能一样，你可以选择一个你想要传输的东西然传输到linux服务器上。简单截图如下：
![rz命令执行效果图][7]

`sz`命令示例，在命令行下输入 `sz filename` 回车同样会调出一个对话框，操作截图如下：

![sz命令执行效果图][8]

*上传完war包之后需要做的一个操作就是重启tomcat服务器，重启命令：*
```shell
 sudo -u tomcat -H /usr/local/apache-tomcat-8.0.32/bin/shutdown.sh && sudo -u tomcat -H /usr/local/apache-tomcat-8.0.32/bin/startup.sh
```

>mysql数据库维护

遇到mysql数据库维护的时候请使用`mysqldump`命令将数据库导成sql脚本然后用`sz`命令将sql脚本下载下来丢给开发让他们自己在他们的开发数据库中还原然后进行操作，如果有数据结构或者表结构更新的，也要求开发写成sql脚本然后丢给运维。运维需要做是：使用`rz`命令将sql脚本传到服务器上，更新mysql数据库，用到命令如下：
>导出mysql数据库为sql脚本
```shell
mysqldump -u root -p safeguard >> safeguard-`date +%F`.sql
:<yourpassword>
sz safeguard-`date +%F`.sql
```
>更新mysql
```shell
rz 
mysql -u root -p [Enter]
:<yourpassword>

mysql> use safeguard;
mysql> source yourscrpit.sql;
```


  [1]: http://a.hiphotos.baidu.com/image/pic/item/ac345982b2b7d0a274b7c1f4c3ef76094b369a59.jpg
  [2]: http://f.hiphotos.baidu.com/image/pic/item/b151f8198618367acf85bab426738bd4b31ce54f.jpg
  [3]: http://h.hiphotos.baidu.com/image/pic/item/8718367adab44aed39427b8dbb1c8701a18bfb4f.jpg
  [4]: http://f.hiphotos.baidu.com/image/pic/item/c2cec3fdfc03924503b824668f94a4c27d1e254e.jpg
  [5]: http://c.hiphotos.baidu.com/image/pic/item/2cf5e0fe9925bc31fe50c4f156df8db1cb13704e.jpg
  [6]: http://a.hiphotos.baidu.com/image/pic/item/cf1b9d16fdfaaf516bee44d6845494eef01f7a4e.jpg
  [7]: http://b.hiphotos.baidu.com/image/pic/item/6a63f6246b600c33d6071ba1124c510fd9f9a159.jpg
  [8]: http://c.hiphotos.baidu.com/image/pic/item/a8773912b31bb051ea5a76413e7adab44aede059.jpg