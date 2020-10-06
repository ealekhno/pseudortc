#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/of.h>
#include <linux/platform_device.h>
#include <linux/proc_fs.h>
#include <linux/random.h>
#include <linux/rtc.h>
#include <linux/sched.h>
#include <linux/seq_file.h>
#include <linux/spinlock.h>

MODULE_LICENSE("GPL");

#define FAST 1
#define NORM 2
#define SLOW 4
#define RAND 8

static void pseudo_rtc_cleanup(void);
static int pseudo_rtc_init(void);
static int pseudo_rtc_probe(struct platform_device *);
static int pseudo_rtc_proc(struct device *, struct seq_file *);
static int pseudo_rtc_read_time(struct device *, struct rtc_time *);
static int pseudo_rtc_set_time(struct device *, struct rtc_time *);
static ssize_t p_write(struct file *, const char *, size_t , loff_t *);
static void updater(struct timer_list *);

volatile uint64_t t;
volatile int64_t coeff = NORM;
static struct timer_list tl;
static struct platform_device *pseudo_rtc_device;
static struct proc_dir_entry *input_procfile;

static const struct file_operations fops = {
	.write = p_write,
};

static struct platform_driver pseudo_rtc_driver = {
	.probe = pseudo_rtc_probe,
	.driver = {
		.name = "pseudortc",
		.of_match_table = of_match_ptr(pseudo_rtc_match),
	},
};


static const struct rtc_class_ops pseudo_rtc_ops = {
	.read_time = pseudo_rtc_read_time,
	.set_time = pseudo_rtc_set_time,
	.proc = pseudo_rtc_proc,
};

module_init(pseudo_rtc_init);
module_exit(pseudo_rtc_cleanup);

static ssize_t
p_write(struct file *unused1, const char *ubuf, size_t len, loff_t *unused2)
{
	int lc = 0;
	char kbuf[20] = {};

	len = len > sizeof(kbuf) ? sizeof(kbuf) - 1 : len;
	if (copy_from_user(kbuf, ubuf, len) != 0)
		return -EFAULT;
	if (strncmp(kbuf, "slow", 3) == 0)
		lc = SLOW;
	if (strncmp(kbuf, "fast", 3) == 0)
		lc = FAST;
	if (strncmp(kbuf, "norm", 3) == 0)
		lc = NORM;
	if (strncmp(kbuf, "rand", 3) == 0)
		lc = RAND;
	coeff = lc != 0 ? lc : coeff;
	return len;
}

static void
updater(struct timer_list *unused)
{
	int enlarger = 0;
	char rnd;

	switch (coeff) {
		case SLOW:
	        enlarger = 7;
		break;
		case FAST:
	        enlarger = 15;
		break;
		case NORM:
	        enlarger = 10;
		break;
		case RAND:
		get_random_bytes(&rnd, sizeof(rnd));
/* dont go too slow dont go too fast */
		rnd += 5;
		rnd &= 0x0F;
	        enlarger = rnd;
		break;
		default:
	        enlarger = 5;
		break;
	}
	t += enlarger;
	tl.expires += HZ / 10;
        add_timer(&tl);
        return;
}

static int
pseudo_rtc_proc(struct device *unused, struct seq_file *seq)
{
	seq_printf(seq, "Statistic statistics\n");
	return 0;
}

/*
 * t / 100 everywhere comes from the need to have the ability to slow down / speed up (fixed-point)
 * timer fires every 1 second, and the slow case the last (decimal) digit of t saves the "half-progres" made every 2nd tick
 */

static int
pseudo_rtc_read_time(struct device *unused, struct rtc_time *time)
{
	rtc_time64_to_tm(t / 100, time);
	return 0;
}

static int
pseudo_rtc_set_time(struct device *unused, struct rtc_time *time)
{
	t = rtc_tm_to_time64(time) * 100;
	return 0;
}

static int
pseudo_rtc_probe(struct platform_device *pdev)
{
	struct rtc_device *pseudo_rtc;

	pseudo_rtc = devm_rtc_device_register(&pdev->dev, pdev->name, &pseudo_rtc_ops, THIS_MODULE);
	if (IS_ERR(pseudo_rtc))
		return -ENOTTY;
	return 0;
}

static int
pseudo_rtc_init(void)
{
	int rv = 0;

	input_procfile = proc_create("driver/rtcspeed", 0644, NULL, &fops);
	if (IS_ERR(input_procfile)) {
		rv = -ENOMEM;
		goto out;
	}

	timer_setup(&tl, updater, 0);
	tl.expires = jiffies + HZ;
	add_timer(&tl);

	if ((rv = platform_driver_register(&pseudo_rtc_driver)))
		goto out1;
	if ((pseudo_rtc_device = platform_device_alloc("pseudortc", 0)) == NULL) {
		rv = -ENOMEM;
		goto out2;
	}
	if ((rv = platform_device_add(pseudo_rtc_device)))
		goto out3;
	return rv;
out3:
	platform_device_unregister(pseudo_rtc_device);
out2:
	platform_driver_unregister(&pseudo_rtc_driver);
out1:
	del_timer_sync(&tl);
out:
	return rv;
}

static void
pseudo_rtc_cleanup(void)
{
	remove_proc_entry("driver/rtcspeed", NULL);
	del_timer_sync(&tl);
	platform_device_unregister(pseudo_rtc_device);
	platform_driver_unregister(&pseudo_rtc_driver);
	return;
}

