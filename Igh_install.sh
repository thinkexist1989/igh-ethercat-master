#! /bin/sh 
./bootstrap
./configure --enable-cycles --enable-sii-assign --enable-hrtimer --enable-8139too=no --prefix="/opt/etherlab" --with-linux-dir=/usr/src/linux-headers-$(uname -r)

make clean
make all modules

# run in su mode
sudo make modules_install install 
sudo ldconfig
sudo depmod

# configuration
if [[ -f "/etc/init.d/ethercat" ]]; then
  sudo rm /etc/init.d/ethercat
fi

sudo ln -s /opt/etherlab/etc/init.d/ethercat /etc/init.d/ethercat

if [[ -f "/usr/bin/ethercat" ]]; then
  sudo rm /usr/bin/ethercat
fi

sudo ln -s /opt/etherlab/bin/ethercat /usr/bin/ethercat

su -c "echo 'KERNEL==\"EtherCAT[0-9]*\", MODE=\"777\"' > /etc/udev/rules.d/99-EtherCAT.rules"

if [[ -f "/etc/sysconfig" ]];then
  sudo rm -r /etc/sysconfig
else
  sudo mkdir /etc/sysconfig
fi

sudo ln -s /opt/etherlab/etc/sysconfig/ethercat /etc/sysconfig/ethercat

interfaces=$(ip link show  | grep -oP "(^\d*: )\K(e[tn][a-z0-9]*)")
iface=$(echo ${interfaces} | head -n1 | cut -d " " -f1)
MAC=$(cat /sys/class/net/${iface}/address)

sudo sed -i --follow-symlinks "s/MASTER0_DEVICE=\"\"/MASTER0_DEVICE=\"${MAC}\"/g" "/etc/sysconfig/ethercat"
sudo sed -i --follow-symlinks 's/DEVICE_MODULES=\"\"/DEVICE_MODULES=\"generic\"/g' ${ETHERCAT_SYSCONFIG}

# test
sudo /etc/init.d/ethercat status
sudo /etc/init.d/ethercat start
sudo /etc/init.d/ethercat status
sudo /etc/init.d/ethercat stop
sudo /etc/init.d/ethercat status
sudo /etc/init.d/ethercat restart
sudo /etc/init.d/ethercat status

echo "Done."

