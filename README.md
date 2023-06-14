<div align="center">
  <img src="./rocos-app.png" alt="" height="150">
  <h1>IgH EtherCAT Master</h1>
  <blockquote>IgH EtherCAT Master for Linux </blockquote>
</div>


IgH EtherCAT Master是一个开源的EtherCAT主站。本分支是IgH EtherCAT Master的1.5.2版本。详细信息可以去[https://etherlab.org/en/ethercat/](https://etherlab.org/en/ethercat/)查看。

## 下载

```bash
git clone https://github.com/landaurobotics/igh-ethercat-master.git
```

## 编译

```bash
./bootstrap
./configure --enable-cycles --enable-sii-assign --enable-hrtimer --enable-8139too=no --prefix="/opt/etherlab" --with-linux-dir=/usr/src/linux-headers-$(uname -r)
```

根据[ethercat_doc.pdf](documentation/ethercat_doc.pdf)中的描述，其主要的配置选项含义如下：

- `--prefix`，安装路径前缀，默认是`/usr/local/`（文档中写的默认值是`/opt/etherlab`，但实际不是）
- `--enable-8139too=no`，不编译8139too驱动，经过测试，5.15以上内核只能用generic
- `-enable-cycles`，使用cpu时间戳计时，在Intel的CPU架构上能够得到更加精确的时间计算
- `--enable-sii-assign`，在从站配置期间启动用将SII访问分配给PDI（Process Data Interface）层
- `--enable-hrtimer`，使用高分辨率时钟使得主站状态机在发送帧之间休眠
- `--with-linux-dir=/usr/src/linux-headers-$(uname -r)`，Linux内核源文件地址

之后就可以编译了

```bash
make
make modules
```

## 安装

```bash
sudo make install
sudo make modules_install
sudo depmod
```

IgH EtherCAT Master将被安装在`/opt/etherlab`目录下

## 配置

首先将以下3个文件在系统相应目录下建立软连接

```bash
sudo mkdir /etc/sysconfig #如果没有则新建目录
sudo ln -s /opt/etherlab/etc/sysconfig/ethercat /etc/sysconfig/ethercat
sudo ln -s /opt/etherlab/etc/init.d/ethercat /etc/init.d/ethercat
sudo ln -s /opt/etherlab/bin/ethercat /usr/bin/ethercat
```

配置udev规则

```bash
su -c "echo 'KERNEL==\"EtherCAT[0-9]*\", MODE=\"777\"' > /etc/udev/rules.d/99-EtherCAT.rules"
```

查找期望作为主站的网口MAC地址

```bash
ifconfig -a
```

```bash
enp1s0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        ether c4:00:ad:86:19:2f  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        device memory 0xdf700000-df7fffff

enp2s0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        ether c4:00:ad:86:19:31  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        device memory 0xdf400000-df4fffff

enp3s0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        ether c4:00:ad:86:19:30  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

假设选定enp1s0作为主站网口，那么需要将其MAC地址`c4:00:ad:86:19:2f`填入ethercat配置文件中。打开`/etc/sysconfig/ethercat`文件

```bash
sudo vim /etc/sysconfig/ethercat
```

在第27行找到MASTER0_DEVICE，将相应的值改为`c4:00:ad:86:19:2f`。

```bash
MASTER0_DEVICE="c4:00:ad:86:19:2f"
```

同时在第60行，找到DEVICE_MODULES，将相应的值改为`generic`。

```bash
DEVICE_MODULES="generic"
```

保存退出。
## 使用

在配置好之后，可以通过以下指令来启动ethercat主站或查看主站状态。

查看主站状态

```bash
sudo /etc/init.d/ethercat status
```

启动主站

```bash
sudo /etc/init.d/ethercat start
```

停止主站

```bash
sudo /etc/init.d/ethercat stop
```

重启主站
  
```bash
sudo /etc/init.d/ethercat restart
```
