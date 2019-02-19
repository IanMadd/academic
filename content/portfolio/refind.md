+++
# Date this page was created.
date = 2019-02-14T00:00:00

# Project title.
title =  "Install Guide for the rEFInd Boot Manager"

# Project summary to display on homepage.
summary = "Instructions for installing the rEFInd Boot Manager"

# Optional image to display on homepage (relative to `static/img/` folder).
image_preview = "/headers/refind_banner-alpha.png"

# Tags: can be used for filtering projects.
# Example: `tags = ["machine-learning", "deep-learning"]`
tags = ['other']

# Optional external URL for project (replaces project detail page).
external_link = ""

# Does the project detail page use math formatting?
math = true

# Optional featured image (relative to `static/img/` folder).
[header]
    image = "/headers/refind_banner-alpha.png"
    caption = ""

+++

# Introduction

[rEFInd](http://www.rodsbooks.com/refind/) is a boot manager which automatically detects EFI bootloaders and shows a graphical interface allowing the user boot multiple operating systems that may be located on internal or external hard drives.

These instructions will show you how to install rEFInd on a computer running macOS.

# Table of Contents

1. [Download rEFInd](#download)
2. [Disable System Integrity Protection](#disableSIP)
3. [Install rEFInd with the automatic installer](#automatic)
    1. [Re-enable System Integrity Protection](#automaticEnableSIP)
4. [Install rEFInd with the manual installer](#manual)
    1. [Identify System](#manualIdentifySystem)
    2. [Mount Your EFI System Partition](#manualMountEFI)
    3. [Move the rEFInd files](#manualMoveRefindFiles)
    4. [Modify rEFInd files](#manualModifyFiles)
    5. [Bless rEFInd](#manualBlessRefind)
    6. [Unmount the rEFInd directory](#manualUnmount)
    7. [Re-enable System Inegrity Protection](#manualReenableSIP)

<br>

# Download rEFInd {#download}

Download the latest version of rEFInd from [SourceForge](https://sourceforge.net/projects/refind/).

<br>

# Disable System Integrity Protection {#disableSIP}

[System Integrity Protection](https://support.apple.com/en-us/HT204899) (SIP) prevents certain folders from being modified even by the root user or by a user with root priveleges. Mac OS 10.11 (El Capitan) and later have SIP turned on by default. SIP must be disabled in order to install rEFInd.

You should re-enable SIP after rEFInd has been installed. Read the instructions at the end of the installation to re-enable SIP.

To check if System Integrity Protection is enabled, open Terminal and enter:

```
csrutil status
```

If it returns ```System Integrity Protection status: enabled.```, follow these steps to disable it before installing rEFInd:

1. Restart you computer.
2. While it's restarting hold down Command-R (⌘R). This will start your computer in [Recovery mode](https://support.apple.com/en-us/HT201314).
3. After it's restarted, click on the Utilities menu and select Terminal.
4. Enter ```csrutil disable```.
5. Restart your computer normally.

<br>

{{% alert note %}}
System Integrity Protection protects your computer from malicious software. Re-enable it after you finish installing rEFInd. There are instructions to re-enable SIP after the manual and automatic installation instructions.
{{% /alert %}}

<br>

# Automatic rEFInd Installer {#automatic}

Uncompress the rEFInd zip file that you downloaded from SourceForge.

Open Terminal and navigate into the rEFInd folder that you've downloaded.

Then enter:
```
./refind-install
```

This will run an automatic installer that will install rEFInd in your EFI partition.

<br>

## Re-enable System Integrity Protection {#automaticEnableSIP}

After you finish installing rEFInd, you should re-enable System Integrity Protection (SIP). The process of re-enabling SIP is almost identical to
disabling it:

1. Restart you computer.
2. While it's restarting hold down Command-R (⌘R). This will start it in [Recovery mode](https://support.apple.com/en-us/HT201314).
3. Click on the Utilities menu and select Terminal.
4. Enter ```csrutil enable```.
5. Restart your computer normally.

<br>

## That's it {#thatsItAutomatic}

After restart your computer will load the rEFInd boot manager automatically. You will see a screen like the one below; use the left and right arrows to select an operating system.

<img src="/portfolio/refind.png">

<br>

# Manual installation {#manual}

These instructions will show you how to install rEFInd manually by copying specific files from the rEFInd zip file to a folder on your computer.

<br>

## Identify System {#manualIdentifySystem}

First you need to identify if you have a 32-bit or 64-bit system.

Open Terminal and enter:

```
ioreg -l -p IODeviceTree | grep firmware-abi
```

Terminal will return either ```EFI32``` or ```EFI64```.

<br>

## Mount your EFI System Partition. {#manualMountEFI}

The EFI System Partition (ESP) contains files that tell your computer which operating system to load when it is starting up.

To modify the ESP, you have to mount it by creating a folder to mount to.

### First create a folder in Terminal:

```
sudo mkdir Volumes/ESP
```

### Then mount the ESP to that folder:

```
sudo mount -t msdos /dev/disk0s1 Volumes/esp
```

<br>

## Move the rEFInd files {#manualMoveRefindFiles}

First, create a directory for the rEFInd files:

```
sudo mkdir -p /Volumes/esp/efi/refind
```

In Terminal, navigate into the unzipped folder you downloaded from SourceForge and copy the rEFInd files to the new rEFInd folder you just created:

```
sudo cp -r refind/* /Volumes/esp/efi/refind/
```
<br>

## Modify rEFInd Files{#manualModifyFiles}

Remove the unnecessary versions of rEFInd from `/Volumes/ESP/efi/refind/` that you won't be using.

Apple computers don't use an ARM CPU, so you can delete this file:

* refind_aa64.efi

```
sudo rm Volumes/esp/efi/refind/refind_aa64.efi
```

If you have a 64-bit computer, remove this file:

* refind_ia32.efi

```
sudo rm Volumes/esp/efi/refind/refind_ia32.efi
```

If you have a 32-bit computer, remove this file:

* refind_x64.efi

```
sudo rm /Volumes/ESP/efi/refind/refind_x64.efi
```

If this is your first installation, there's a file called `refind.conf-sample`. Change this to `refind.conf`:

```
sudo mv /Volumes/ESP/efi/refind/refind.conf-sample /Volumes/ESP/efi/refind/refind.conf
```

<br>

## Bless rEFInd {#manualBlessRefind}

Bless rEFInd

The bless command makes a volume bootable. To bless this installation rEFInd, enter:

```
sudo bless --mount /Volumes/ESP --setBoot --file /Volumes/ESP/efi/refind/refind_x64.efi --shortform
```

<br>

## Unmount the rEFInd directory {#manualUnmount}

You can restart your computer now and it will automatically unmount the ESP and run rEFInd after it restarts. If you want to continue using your computer without the ESP directory, enter the following command:

```
diskutil unmount /dev/disk0s1
```
or

```
diskutil unmount /Volumes/ESP
```

<br>

## Re-enable System Integrity Protection {#manualReenableSIP}

If you disabled System Integrity Protection you should re-enable it after you've finished install rEFInd. The process of re-enabling System Integrity Protection is almost identical to
disabling it:

1. Restart you computer.
2. While it's restarting hold down Command-R (⌘R). This will start your computer in [Recovery mode](https://support.apple.com/en-us/HT201314).
3. Click on the Utilities menu and select Terminal.
4. Enter ```csrutil enable```.
5. Restart your computer normally.

<br>

## That's it

After restart your computer will load the rEFInd boot manager automatically. You will see a screen like the one below; use the left and right arrows to select an operating system.

<img src="/portfolio/refind.png">

<br>