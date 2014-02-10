Make RT-Thread Shell
--------------------
Automatic generate RT-Thread Project for STM32F429

Reference :  
1. [stm32f429 hackpad][1]    
2. [在STM32F429 Discovery上运行RT-Thread实时操作系统][2]


### Install ToolChain
安裝跟設定是參考連結
```
$> apt-get install gcc-arm-none-eabi
```

若因為 Ubuntu 版本較舊，而找不到 apt 來源的話，請進行以下操作:
```
$> sudo add-apt-repository ppa:terry.guo/gcc-arm-embedded
$> sudo apt-get update
$> sudo apt-get install gcc-arm-none-eabi
```
```
$> export PATH=/usr/bin:$PATH
```

或是直接下載 prebuilt package，然後解壓縮放到自己習慣的目錄下，
如 $HOME/STM32/toolchain，一個名為envsetup.sh的bash script 可協助您設定環境變數

```
#!/bin/bash
echo “setting build environment for STM32F4″
export STM32_PATH=$HOME/STM32
export PATH=$STM32_PATH/toolchain/gcc-arm-none-eabi-4_8-2013q4/bin/:$STM32_PATH/toolkit/bin:$PATH
```

### Install Stlink
安裝跟設定是參考連結
```
$> git clone https://github.com/texane/stlink.git
$> cd stlink
$> ./autogen.sh
$> ./configure
$> make
$> make install
```
在 Ubuntu 下用 stlink，記得要把 49-stlinkv2.rules 檔案複製到 /etc/udev/rules.d/ 目錄下

### Install OpenOCD
安裝跟設定是參考連結
```
$> git clone git://git.code.sf.net/p/openocd/code openocd
$> cd openocd
$> ./bootstrap
$> ./configure --prefix=/usr/local --enable-stlink
$> echo -e "all:\ninstall:" > doc/Makefile
$> make
$> sudo make install

```

### Build
```
$> bash mkRTT.sh
$> cd RTT
$> vim rtconfig.py
```
```
if  CROSS_TOOL == 'gcc':                                                        
    PLATFORM    = 'gcc'                                                         
    EXEC_PATH   = r'/home/ham/sat/bin' <=== modified your arm gcc path
```
```
$> scons
$> st-flash write rtthread.bin 0x8000000
```
[1]: https://stm32f429.hackpad.com/NOTE-WbiooOfkaoR
[2]: http://www.devlabs.cn/?p=209
