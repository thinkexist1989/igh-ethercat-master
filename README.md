<div align="center">
  <img src="./rocos-app.png" alt="" height="150">
  <h1>IgH EtherCAT Master</h1>
  <blockquote>IgH EtherCAT Master for Linux </blockquote>
</div>


IgH EtherCAT Master是一个开源的EtherCAT主站。本分支是IgH EtherCAT Master的1.5.2版本。详细信息可以去[https://etherlab.org/en/ethercat/](https://etherlab.org/en/ethercat/)查看。

## 下载

```bash
$ git clone https://github.com/landaurobotics/igh-ethercat-master.git
```

## 编译

```bash
$ ./bootstrap
$ ./configure --enable-cycles --enable-sii-assign --enable-hrtimer --enable-8139too=no --prefix="/opt/etherlab" --with-linux-dir=/usr/src/linux-headers-$(uname -r)
```

```bash
$ make
$ make modules
```


## 配置



## 使用

