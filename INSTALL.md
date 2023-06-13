This is the INSTALL file of the IgH EtherCAT Master.

vim: set spelllang=en spell tw=78

# Building and installing

The complete build and installation procedure is described in the respective
section of the
[documentation](https://gitlab.com/etherlab.org/ethercat/-/jobs/artifacts/stable-1.5/raw/pdf/ethercat_doc.pdf?job=pdf).

---

For the impatient: The procedure mainly consists of calling

```bash
./bootstrap # to create the configure script, if downloaded from the repo

./configure
make all modules
```

... and as root:

```bash
make modules_install install
depmod
```

... and linking the init script and copying the sysconfig file from $PREFIX/etc
to the appropriate locations and customizing the sysconfig file.

```bash
ln -s ${PREFIX}/etc/init.d/ethercat /etc/init.d/ethercat
cp ${PREFIX}/etc/sysconfig/ethercat /etc/sysconfig/ethercat
vi /etc/sysconfig/ethercat
```

Make sure, that the 'udev' package is installed, to automatically create the
EtherCAT character devices. The character devices will be created with mode
0660 and group root by default. If you want to give normal users reading
access, create a udev rule like this:

```bash
echo KERNEL==\"EtherCAT[0-9]*\", MODE=\"0664\" > /etc/udev/rules.d/99-EtherCAT.rules
```

Now you can start the EtherCAT master:

```bash
/etc/init.d/ethercat start
```

Have a look at the [examples subdirectory](examples/) for some application
examples.

---

Have fun!

---
