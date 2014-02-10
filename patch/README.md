RT_Thread For STM32F429 patch
------------------------------

### Create patch 
```
$> diff -Naur standard_moodle my_moodle > patch.txt
```

### Using patch

```
patch < rtconfig.py.patch ../RTT/rtconfig.py  
patch < root_SConstruct.patch ../RTT/SConstruct   
patch < lib_SConscript.patch ../RTT/Libraries/SConscript   
patch < application.c.patch ../RTT/applications/application.c 
```
