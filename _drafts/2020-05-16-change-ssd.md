---
layout:   post
excerpt_separator: <!--more-->
title:    "Switching the SSD on my Dell Latitude notebook"
category: dev
tags:     dell linux ubuntu
comments: true
---

1. insert new SSD into an external case and connect it
2. create an [Clonezilla](https://clonezilla.org/clonezilla-live.php) USB stick with [Tuxboot](https://tuxboot.org/) (using the "clonezilla_live_alternative" because I am using UEFI secure boot) 
3. boot Clonezilla from the USB stick and copy the whole SSD (...)
4. uninstall the old SSD and install the new SSD

...

In my case, GRUB showed up and Windows booted just fine. But Ubuntu 
When selecting "Advanced options for Ubuntu" in GRUB, boot mode: error
Booting from an Ubuntu USB stick: SSD not recognized at all
Hint: when starting the Ubuntu installation https://help.ubuntu.com/rst

To switch from RAID to AHCI, I performed [these steps](https://support.thinkcritical.com/kb/articles/switch-windows-10-from-raid-ide-to-ahci) 

   1. Open an administrator command promt and enter `bcdedit /set {current} safeboot minimal`
   2. Restart and enter BIOS Setup
   3. Change "SATA Operation" from "RAID on" to "AHCI", save, and reboot to Windows
   4. Open an administrator command promt, enter `bcdedit /deletevalue {current} safeboot`, and restart one more time




Markdown contents

{% highlight groovy %}
source code
{% endhighlight %}
