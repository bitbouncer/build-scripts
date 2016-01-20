build-scripts
=================
Common buildscripts for bitbouncer repos. 

Downloads and build all required libs. The purpose is to have a common build system to make it trivial to use Visual Studio during development and deploy production code on Linux

Downloads and builds (where needed)
  * cares              1.10.0 
  * libcurl            7.46.0 
  * joyent_http_parser 2.3 
  * boost              1.59
  * snappy             1.1.3
  * avro_cpp           1.7.7
  * openSSL            1.0.2e (windows+raspberry)
  * zlib               1.2.8  (windows)
  * 
  
  
## Windows x64 - Visual Studio 12

Get and build nessessary dependencies
```
Install Visual Studio, cmake, nasm, git and active perl manually, make sure active perl is before git in PATH

mkdir source
cd source
git clone https://github.com/bitbouncer/build-scripts.git
build-scripts\windows_x64_vc12_setup_3rd_part.bat
build-scripts\windows_x64_vc12_get_csi.bat
build-scripts\windows_x64_vc12_rebuild_csi.bat
```

## Ubuntu 14 x64:

Install build tools
```
sudo apt-get update
sudo apt-get install -y automake autogen shtool libtool git wget cmake unzip build-essential g++ python-dev autotools-dev libicu-dev zlib1g-dev openssl libssl-dev libcurl4-openssl-dev libbz2-dev libcurl3 libpq-dev

```

Get and build necessary dependencies
```
mkdir source
cd source
git clone https://github.com/bitbouncer/build-scripts.git
bash build-scripts/linux_setup_3rd_part.sh
(run this part first - it will stop after a sudo)

bash build-scripts/linux_get_csi.sh
bash build-scripts/linux_rebuild_csi.sh
```


## Centos 7 x64:

Install build tools (as root)
```
yum -y update
yum -y groupinstall 'Development Tools'
yum -y install automake autogen libtool git wget cmake unzip openssl redhat-lsb-core postgresql-devel openssl-devel bzip2-devel openldap  openldap-clients openldap-devel libidn-devel
```

Get and build necessary dependencies
```
mkdir source
cd source
git clone https://github.com/bitbouncer/build-scripts.git
bash build-scripts/linux_setup_3rd_part.sh
bash build-scripts/linux_get_csi.sh
bash build-scripts/linux_rebuild_csi.sh
```

## Raspberry Pi - cross compiling on ubuntu14 x32

Install build tools
```
sudo apt-get -y install cmake wget unzip cmake wget wput libpcre3 libpcre3-dev build-essential git subversion 
mkdir -p ~/xtools
cd ~/xtools
git clone https://github.com/raspberrypi/tools.git --depth 1
cd ..
echo "export PATH=~/xtools/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin:\$PATH" >> ~/.bashrc
source ~/.bashrc


```
Get and build nessessary dependencies 
```
mkdir raspbian_source
cd raspbian_source
git clone https://github.com/bitbouncer/build-scripts.git
bash build-scripts/raspbian_ubuntu32_setup_3rd_part.sh
bash build-scripts/raspbian_ubuntu32_get_csi.sh
bash build-scripts/raspbian_ubuntu32_rebuild_csi.sh
```


License:
- Boost Software License, Version 1.0.



