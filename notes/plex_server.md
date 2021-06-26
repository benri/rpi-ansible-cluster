# How to Setup a Raspberry Pi Plex Server

ref: https://pimylifeup.com/raspberry-pi-plex-server/

In this tutorial, I go through all the steps to getting your very own Raspberry Pi plex server up and running.

This project is perfect for anyone who wants to have a media server that can be accessed by anyone within a household. You can also set it up to be accessed outside your local network.

Plex is a client-server setup where the client directly streams data from the Plex media server. This setup means you can have all your movies, music, and photos located on the one device, the server. In this case, we will be using the Raspberry Pi.

You can then have multiple clients connect to the same server. It is great as you don’t need to have multiple copies of the same media across several devices.

The Plex client is supported on a ton of devices including Windows, Apple, Android, Amazon Fire TV, Chromecast, Xbox, PlayStation, Linux, and so much more. It really is a fantastic home media solution.

If you just want a single client without the whole server setup, then something like the [Raspberry Pi Kodi](https://pimylifeup.com/raspberry-pi-kodi/) media center might interest you more.

If you are after an alternative completely free media server, you can also [check out Jellyfin](https://pimylifeup.com/raspberry-pi-jellyfin/).

## Setting up the Raspberry Pi Plex Server

### Preparing your Pi for Plex

#### 1.

Now before we install the Plex Media Server software to the Raspberry Pi, we need first to ensure our operating system is entirely up to date by running the following two commands.

```
sudo apt-get update
sudo apt-get upgrade
```

#### 2.

To install the Plex packages to the Raspberry Pi, we will need to add the official Plex package repository.

Before we do that we need to install the "`apt-transport-https`" package.

This package allows the "`apt`" package manager to retrieve packages over the “https” protocol that the Plex repository uses.

Install the package by running the command below.

```
sudo apt-get install apt-transport-https
```

#### 3.

Let’s now add the Plex repositories to the "`apt`" package managers key list.

This key is used to ensure the files that you are downloading are in fact from that repository and signed by that key.

Run the following command to download and add the key to the package manager.

```
curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -
```

#### 4.

With the Plex GPG key now added, we can finally add the official plex repository to the sources list by running the following command.

```
echo deb https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
```

#### 5.

As we have just added a new repository to our sources, we will need to run the "update" command again to refresh the package list.

```
sudo apt-get update
```

If you get the error "`/usr/lib/apt/methods/https could not be found.`" Then the https transport package hasn’t been installed. Double check that it has been installed correctly.

### Installing Plex to your Raspberry Pi

#### 1.

Now that we have set up our Raspberry Pi so that it can read from Plex’s official package repositories we can go ahead and finally install the Plex Media server package to the Pi.

To install the "`plexmediaserver`" package, run the command below.

```
sudo apt install plexmediaserver
```

#### 2.

The installation process for Plex sets up a few different things for us.

The first is that it creates a user and group for Plex to run under. This user and group is called "`plex`".

It also will set up two directories, one where to store files temporarily that Plex is transcoding. You can find this folder at "`/var/lib/plexmediaserver/tmp_transcoding`".

The second directory is where Plex will store all the metadata it retrieves for your media. This folder can be found at "`/var/lib/plexmediaserver/Library/Application Support`"

#### 3.

As Plex is running a different user to the Raspberry Pi’s default "`pi`" user, you will need to make sure you have permissions set correctly on your drive.

If you need help setting up your external drive with Plex, you can try following our guide on [mounting a USB drive on Raspbian](https://pimylifeup.com/raspberry-pi-mount-usb-drive/).