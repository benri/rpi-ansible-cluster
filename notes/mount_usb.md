# Raspberry Pi Mount a USB Drive Tutorial

ref: https://pimylifeup.com/raspberry-pi-mount-usb-drive/

In this guide, we’re going to use a Raspberry Pi to mount a USB drive. We show you both how Raspbian automatically mounts a drive and how to do it manually.

If you’re looking to have this drive accessible over your network, then the [Raspberry Pi samba server](https://pimylifeup.com/raspberry-pi-nas/) is better suited for your needs.

It’s important to know that Raspbian lite currently does not automatically mount your drives. So you will need to either set it up manually or install the software package to have it automatically mount.

Mounting drives is an important skill to have when it comes to working hard drives and file structures in Linux. Once you have a general understanding, it becomes a pretty easy task.

Having a good [understanding of Linux file permissions](https://pimylifeup.com/file-permissions-in-linux/) will make this tutorial a lot easier. If you don’t, then you should still be able to complete this tutorial without issue.

## Mount a USB Drive to the Raspberry Pi Automatically

In the latest version of Raspbian (Stretch), your USB drives should be automatically mounted when it is connected to the Pi.  It is important to know if you do upgrade to Stretch from Jessie there might be compatibility problems with older projects & tutorials.

If you want to check where your drive has been mounted, you can simply use the following command.

```
sudo cat /proc/mounts
```

This will output quite a bit of text. Any USB drives are typically at the bottom of the text as shown in the image below.

As you can see my drive located at `/dev/sda1` has been automatically mounted to `/media/pi/CA1C-06BC`.

The automatic mounting done by Raspbian will be fine for most projects and just regular use. It will retain its mount location whenever you remove and re-insert the drive since it uses the UUID of the drive for the mount folder name. You can also find out the UUID by using the following command: `ls -l /dev/disk/by-uuid`.

You might come across problems if you wish to allow access to the drive to a specific user that isn’t the default user. In our next step, we will mount the drive using the fstab file and force permissions of a given user and group.

## Mount a USB Drive to the Raspberry Pi Manually

If you want to mount the drive to your Raspberry Pi permanently, then we will need to set up the drive in the fstab file.

In this section, you will learn how to identify and mount any attached disk drives.

### Identifying the Disks You Want to Mount

#### 1.

We need first to find out the filesystem name for the drive we want to mount to our Raspberry Pi.

To do this, we will be making use of the "`df`" command.

```
df -h
```

`df` stands for "disk-free", and is typically used to show the available disk space for file systems, but it also displays the name of the filesystem.

#### 2.

From this command, you should see a result as we have below

```
Filesystem      Size  Used Avail Use% Mounted on
/dev/root        29G  3.1G   25G  12% /
devtmpfs        1.8G     0  1.8G   0% /dev
tmpfs           2.0G  8.0K  2.0G   1% /dev/shm
tmpfs           2.0G  8.6M  1.9G   1% /run
tmpfs           5.0M  4.0K  5.0M   1% /run/lock
tmpfs           2.0G     0  2.0G   0% /sys/fs/cgroup
/dev/mmcblk0p1  253M   53M  200M  21% /boot
tmpfs           391M     0  391M   0% /run/user/1000
/dev/sda1       932G  595G  337G  64% /media/pi/My Passport
```

This result lists all the connected storage devices, the name of their filesystem and where they are currently mounted on

#### 3.

Use this result to identify the drive you want to mount.

For example, we want to mount our 1TB "My Passport" drive to our Raspberry Pi. Most external drives will be references under the `/dev/sd**` filesystem name.

So scanning through the list, we can see that this entry matches what we are after.

```
/dev/sda1       932G  595G  337G  64% /media/pi/My Passport
```

From this row, we can find the filesystem name that we need to use for the next few steps is the following.

```
/dev/sda1
```

### Retrieving the Disk UUID and Type

In this section, we will need to take the filesystem name we retrieved in the previous section to find both the UUID (Universal Unique Identifier) and the type of drive.

#### 1.

To find out more information about our drives filesystem, we can make use of the `blkid` tool.

Run the following command to retrieve information about your drive.

```
sudo blkid /dev/sda1
```

Please note that you should replace `/dev/sda1/` with the filesystem name you retrieved in the previous section.

#### 2.

From this command, you should have retrieved a result as we have below

```
/dev/sda1: LABEL="My Passport" UUID="8A2CF4F62CF4DE5F" TYPE="ntfs" PTTYPE="atari" PARTUUID="00042ada-01"
```

Please make a note of the value for both the `UUID` and the `TYPE`.

3.Depending on the "type" of your filesystem, you may need to install additional drivers.

If you are using a drive that has a type of `ntfs` or `exFAT`, you will need to follow the appropriate steps below. Otherwise, you can continue to the next section.

##### NTFS
To be able to use the NTFS format on your Raspberry Pi, you will need to install the NTFS-3g driver.

You can do this by running the following command.

```
sudo apt install ntfs-3g
```

You can find out more about [NTFS on the Raspberry Pi](https://pimylifeup.com/raspberry-pi-ntfs/) by following the guide.

##### exFAT
To add support for the exFAT filesystem, we will need to install two packages.

```
sudo apt install exfat-fuse
sudo apt install exfat-utils
```

These two packages will allow the Raspberry Pi to read and interpret exFAT drives. You can learn more about [exFAT on the Raspberry Pi](https://pimylifeup.com/raspberry-pi-exfat/) by reading our guide.

### Mounting the Drive to the Raspberry Pi

With everything now prepared and the UUID and type of the drive on hand, we can now proceed to mount the drive.

#### 1.

To start, we need to make a directory where we will mount our drive to.

We can do this by running the following command. You can name the folder we are mounting anything, but for this tutorial, we will be using the name `usb1`.

```
sudo mkdir -p /mnt/usb1
```

#### 2.

Let’s now give our `pi` user ownership of this folder by running the command below.

```
sudo chown -R pi:pi /mnt/usb1
```

#### 3.

Next, we need to modify the fstab file by running the command below.

```
sudo nano /etc/fstab
```

#### 4.

The lines that we add to this file will tell the operating system how to load in and handle our drives.

For this step, you will need to know your drives UUID (`[UUID]`) and TYPE (`[TYPE]`).

Add the following line to the bottom of the file, replacing `[UUID]` and `[TYPE]` with their required values.

```
UUID=[UUID] /mnt/usb1 [TYPE] defaults,auto,users,rw,nofail,noatime 0 0
```

Once done, save the file by pressing CTRL + X, followed by Y, then the ENTER key.

#### 5.

Now since the Pi will likely of automatically mounted the drive, we will need to unmount the drive.

A simple way to do this is to use the following command (Replace `/dev/sda1` with the filesystem name you found earlier in this guide).

```
sudo umount /dev/sda1
```

#### 6.

Once the drive has been umounted, we can now go ahead and mount it again.

To mount the drive again, you can use the following command.

```
sudo mount -a
```

The drive should now be mounted using the changes we made to the fstab file.

#### 7.

If you want to make sure the drives are restored after the Pi has been shut down then run the following command:

```
sudo reboot
```

#### 8.

The drives should be automatically mounted after the Raspberry Pi has finished rebooting.

Hopefully, you have your drive mounted to the Raspberry Pi now. If you have any trouble, then be sure to check out the troubleshooting guide below.
