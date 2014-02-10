#!/bin/bash

CPATH=$PWD
TEMP=$CPATH/tmp
RTT=$PWD/RTT

MKDIR=/bin/mkdir
WGET=/usr/bin/wget
EXTRA=/usr/bin/7z
COPY=/bin/cp
REMOVE=/bin/rm
UNZIP=/usr/bin/unzip
GZIP=/bin/gzip
SCONS=/usr/bin/scons

if [ ! -f $SCONS ]
then
    sudo apt-get intall scons
fi

if [ ! -d $TEMP ]
then
    $MKDIR ${TEMP}
fi

if [ ! -f $TEMP/RT-Thread_1.2.0.7z ]
then
    $WGET https://rt-thread.googlecode.com/files/RT-Thread_1.2.0.7z -P $TEMP
fi

if [ -d $TEMP/RT-Thread_1.2.0 ]
then
    $REMOVE $TEMP/RT-Thread_1.2.0
fi

$EXTRA x -aoa $TEMP/RT-Thread_1.2.0.7z -o$TEMP

if [ -d $RTT ]
then
    $REMOVE -Rf $RTT
fi

$MKDIR $RTT
cd $RTT
$COPY -R $TEMP/RT-Thread_1.2.0/bsp/stm32f40x/* .

$MKDIR rt_thread
$COPY -R $TEMP/RT-Thread_1.2.0/components rt_thread/
$COPY -R $TEMP/RT-Thread_1.2.0/src rt_thread/
$COPY -R $TEMP/RT-Thread_1.2.0/include rt_thread/
$COPY -R $TEMP/RT-Thread_1.2.0/libcpu rt_thread/
$COPY -R $TEMP/RT-Thread_1.2.0/bsp/stm32f40x/rtconfig.h rt_thread/
$COPY -R $TEMP/RT-Thread_1.2.0/tools rt_thread/
$COPY $TEMP/RT-Thread_1.2.0/bsp/stm32f40x/rtconfig.h rt_thread/

$REMOVE project.uvopt
$REMOVE project.uvproj
$REMOVE template.uvproj

$REMOVE -R Libraries/CMSIS
$REMOVE -R Libraries/STM32F4xx_StdPeriph_Driver
$REMOVE drivers/stm32f4xx_conf.h

cd ..

if [ ! -f $TEMP/stsw-stm32138.zip ]
then
    $WGET http://www.st.com/st-web-ui/static/active/en/st_prod_software_internet/resource/technical/software/firmware/stsw-stm32138.zip -P $TEMP
fi


if [ ! -d $TEMP/STM32F429I-Discovery_FW_V1.0.1 ]
then
    $UNZIP $TEMP/stsw-stm32138.zip -d $TEMP
fi

cd $TEMP/STM32F429I-Discovery_FW_V1.0.1/
$COPY -R Libraries/CMSIS/ $RTT/Libraries
$COPY -R Libraries/STM32F4xx_StdPeriph_Driver/ $RTT/Libraries
$COPY $TEMP/STM32F429I-Discovery_FW_V1.0.1/Projects/Template/stm32f4xx_conf.h $RTT/Libraries/STM32F4xx_StdPeriph_Driver/inc/
$GZIP $RTT/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_fsmc.c

# patch

cd $CPATH

patch < ./patch/rtconfig.py.patch ./RTT/rtconfig.py
patch < ./patch/root_SConstruct.patch ./RTT/SConstruct
patch < ./patch/lib_SConscript.patch ./RTT/Libraries/SConscript
patch < ./patch/application.c.patch ./RTT/applications/application.c

$COPY ./patch/startup_stm32f429_439xx.S ./RTT/

#cd $RTT
#$SCONS
