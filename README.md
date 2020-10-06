##Virtual RTC device for linux.

#Basics

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
To see the PROCFS statistics you need to compile your kernel with CONFIG_RTC_INTF_PROC and CONFIG_RTC_HCTOSYS_DEVICE set accordingly to 
enable proc interface for devices other than rtc0 and to point to the desired device.

Device speed is controlled by writing to the file /proc/drivers/rtcspeed. Following commands are recognized:
```console
slow
norm
fast
rand
```

#Testing
To ease the testing of the device, a simple shell script is provided.


<details>
  <summary>The driver has been tested on this hardware:</summary>

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
