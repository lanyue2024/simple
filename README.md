# simple
用nginx做http代理，解决网络问题。

## 安装
在Releases下载后运行<start.bat>，代理地址 127.0.0.1:9080。
双击<conf/simple-ca.crt>安装根证书到<受信任的根证书颁发机构>。[<hosts.txt>](https://github.com/lanyue2024/simple/blob/main/hosts.txt)

## 更新
只要下载`hosts.txt`覆盖旧文件，然后重启nginx。
