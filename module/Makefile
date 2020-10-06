ifneq ($(KERNELRELEASE),)
	obj-m := pseudortc.o
else
modules:
	make -C $(LINUX) M=$(PWD) modules
clean:
	make -C $(LINUX) M=$(PWD) clean
endif
