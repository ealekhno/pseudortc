# Virtual RTC device for linux.

## Basics

To build:
```console
cd module
export LINUX="/path/to/linux/kernel"
make modules
```
To remove object files:
```console
cd module
export LINUX="/path/to/linux/kernel"
make clean
```
The module is loaded / unloaded with
```console
insmod pseudortc.ko
rmmod pseudortc
```

To see the PROCFS statistics you need to compile your kernel with CONFIG_RTC_INTF_PROC and CONFIG_RTC_HCTOSYS_DEVICE set accordingly to 
enable proc interface for devices other than rtc0 and to point to the desired device.

Device speed is controlled by writing to the file /proc/drivers/rtcspeed. Following commands are recognized:
```console
slow
norm
fast
rand
```

## Testing
To ease the testing of the device, a simple shell script (test.sh) is provided. It can be found in the project's ./tests/ subdirectory.
This script loads the module being tested, sets its corresponding rtc device from the system clock and then prints out the time it acquires from both
the tested device and the system's standard rtc. After that it waits for approximately 10 seconds (the actual time depends on many factors) and prints out both times again. The whole process is repeated for all the speed settings provided by the tested module. In the end, the module is uloaded.

In order to be able to test devices other than /dev/rtc1 with test.sh, you should edit this line of the script
```console
export THERTC=/dev/rtc1
```
to point to the device in concern.

<details>
  <summary>The driver has been tested on this hardware</summary>

```console
$ uname -a
Linux silverfish 4.19.72-gentoo #18 SMP PREEMPT Sun Oct 4 19:49:23 MSK 2020 x86_64 Intel(R) Core(TM) i3-4030U CPU @ 1.90GHz GenuineIntel GNU/Linux
```

```console
$ lscpu
Архитектура:         x86_64
CPU op-mode(s):      32-bit, 64-bit
Порядок байт:        Little Endian
Address sizes:       39 bits physical, 48 bits virtual
CPU(s):              4
On-line CPU(s) list: 0-3
Thread(s) per core:  2
Ядер на сокет:       2
Сокетов:             1
NUMA node(s):        1
ID прроизводителя:   GenuineIntel
Семейство ЦПУ:       6
Модель:              69
Имя модели:          Intel(R) Core(TM) i3-4030U CPU @ 1.90GHz
Степпинг:            1
CPU MHz:             1895.594
CPU max MHz:         1900,0000
CPU min MHz:         800,0000
BogoMIPS:            3791.19
Виртуализация:       VT-x
L1d cache:           32K
L1i cache:           32K
L2 cache:            256K
L3 cache:            3072K
NUMA node0 CPU(s):   0-3
Флаги:               fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc cpuid aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx f16c rdrand lahf_lm abm cpuid_fault epb invpcid_single pti tpr_shadow vnmi flexpriority ept vpid ept_ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid xsaveopt dtherm ida arat pln pts
```
</details>

<details>
  <summary>These results were obtained</summary>
# ./test.sh
                                                                                                                                                      
setting hwclock to current time                                                                                                                       
reading time                                                               
our clock is 2020-10-06 08:56:20.039673+03:00                              
system clock is 2020-10-06 08:56:19.999431+03:00                           
sleeping 10 seconds                                                                                                                                   
after sleep our clock is 2020-10-06 08:56:31.046310+03:00 
after sleep system clock is 2020-10-06 08:56:30.999175+03:00               
                                                                                                                                                      
                                                                           
going slower                                                                                                                                          
                                                                           
setting hwclock to current time                                                                                                                       
reading time                                                               
system clock is 2020-10-06 08:56:33.999493+03:00                           
our clock is 2020-10-06 08:56:33.535938+03:00                              
sleeping 10 seconds                                                        
after sleep our clock is 2020-10-06 08:56:41.542638+03:00                  
after sleep system clock is 2020-10-06 08:56:44.999169+03:00                                                                                          
                                                                           
                                                                           
going faster                                                               
                                                                           
setting hwclock to current time                                                                                                                       
reading time                                                               
our clock is 2020-10-06 08:56:48.336303+03:00 
system clock is 2020-10-06 08:56:47.999344+03:00 
sleeping 10 seconds
after sleep our clock is 2020-10-06 08:57:04.648990+03:00 
after sleep system clock is 2020-10-06 08:56:58.999128+03:00 
  
  
going random
  
setting hwclock to current time
reading time
system clock is 2020-10-06 08:57:01.999498+03:00 
our clock is 2020-10-06 08:57:01.839920+03:00
sleeping 10 seconds                                                                                                                                   
after sleep system clock is 2020-10-06 08:58:08.999296+03:00               
after sleep our clock is 2020-10-06 08:58:06.519668+03:00                  


</details>

## Bugs
The driver is built without race conditions in mind. On the test system, however, it did not show unexpected behaviour (crashes, hangs, etc).

The driver currently provides only one rtc device with no "easy" option for scalability

The choice to implement control via a separate PROCFS file comes from the need to preserve the kernel tree unmodified, while editing only the module source file. If I am right, the right way to make the default `/proc/driver/rtc` file writeable would be to edit `/drivers/rtc/proc.c`, e.g. the `void rtc_proc_add_device(struct rtc_device *)` function.

Those bugs can be fixed / functionality added if requested.
