+++
# Date this page was created.
date = 2019-02-14T00:00:00

# Project title.
title =  "Install the rEFInd boot manager on a computer running macOS"

# Project summary to display on homepage.
summary = "Instructions for installing the rEFInd Boot Manager on a computer running macOS."

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

[rEFInd](http://www.rodsbooks.com/refind/) is a boot manager which allows you to boot multiple operating systems from internal or external hard drives. rEFInd automatically detects EFI bootloaders and shows a graphical interface allowing the user to select which operating system they want to start.

These instructions will show you how to use the automatic rEFInd installer or to manually install rEFInd on a computer running macOS.

# Table of Contents

1. [Download rEFInd](#download)
2. [Disable System Integrity Protection](#disableSIP)
3. [Install rEFInd with the automatic installer](#automatic)
    1. [Re-enable System Integrity Protection](#automaticEnableSIP)
4. [Install rEFInd with the manual installer](#manual)
    1. [Identify System](#manualIdentifySystem)
    2. [Mount Your EFI System Partition](#manualMountEFI)
    3. [Move the rEFInd files](#manualMoveRefindFiles)
    4. [Remove Unnecessary rEFInd Files](#manualRemoveFiles)
    5. [Rename rEFInd Config File](#manualModifyConfig)
    5. [Bless rEFInd](#manualBlessRefind)
    6. [Unmount the rEFInd directory](#manualUnmount)
    7. [Re-enable System Integrity Protection](#manualReenableSIP)

<br>

# Download rEFInd {#download}

Download the latest version of rEFInd from [SourceForge](https://sourceforge.net/projects/refind/).

<br>

# Disable System Integrity Protection {#disableSIP}

[System Integrity Protection](https://support.apple.com/en-us/HT204899) (SIP) prevents certain folders from being modified even by the root user or by a user with root privileges. Mac OS 10.11 (El Capitan) and later have SIP turned on by default. SIP must be disabled in order to install rEFInd.

Check if System Integrity Protection is enabled:

```
csrutil status
```

If it returns ```System Integrity Protection status: enabled.```, follow these steps to disable SIP before installing rEFInd:

1. Restart your computer.
2. While your computer is restarting hold down Command-R (⌘R). This will start your computer in [Recovery mode](https://support.apple.com/en-us/HT201314).
3. After your computer restarted, click on the **Utilities** menu and select **Terminal**.
4. Enter ```csrutil disable```.
5. Restart your computer normally.

<br>

{{% alert note %}}
System Integrity Protection (SIP) protects your computer from malicious software. Re-enable SIP after you finish installing rEFInd. There are instructions to re-enable SIP at the end of the manual and automatic installation instructions.
{{% /alert %}}

<br>

# Automatic rEFInd Installer {#automatic}

1. Uncompress the rEFInd zip file that you downloaded from SourceForge.
2. Open **Terminal** and navigate into the uncompressed rEFInd folder.
3. Then enter:
```
./refind-install
```

An automatic installer will install rEFInd into your EFI partition.

<br>

## Re-enable System Integrity Protection {#automaticEnableSIP}

After you finish installing rEFInd, you should re-enable System Integrity Protection (SIP). The process of re-enabling SIP is almost identical to
disabling it:

1. Restart you computer.
2. While it's restarting hold down Command-R (⌘R). This will start it in [Recovery mode](https://support.apple.com/en-us/HT201314).
3. Click on the **Utilities** menu and select **Terminal**.
4. Enter ```csrutil enable```.
5. Restart your computer normally.

<br>

## That's it {#thatsItAutomatic}

After restart, your computer will load the rEFInd boot manager automatically. You will see a screen like the one below. Use the left and right arrows to select an operating system.

<img src="/portfolio/refind.png">

<br>

# Manual installation {#manual}

These instructions will show you how to install rEFInd manually by copying specific files from the rEFInd zip file to a folder on your computer.

<br>

## Identify Your System {#manualIdentifySystem}

First you need to identify if you have a 32-bit or 64-bit system.

Open **Terminal** and enter:

```
ioreg -l -p IODeviceTree | grep firmware-abi
```

**Terminal** will return either ```EFI32``` or ```EFI64```.

<br>

## Mount your EFI System Partition. {#manualMountEFI}

The EFI System Partition (ESP) contains files that tell your computer which operating system to load while it is starting up.

To modify your computer's ESP, create an empty folder and then mount the ESP to that folder.

1. Create a folder in Terminal: <br> ```sudo mkdir Volumes/esp```

2. Mount the ESP to that folder: <br> `sudo mount -t msdos /dev/disk0s1 Volumes/esp`

<br>

## Move the rEFInd files {#manualMoveRefindFiles}

Now move the files from the unzipped rEFInd folder to the ESP folder.

1. Create an empty folder in the ESP folder for the rEFInd files: <br> `sudo mkdir -p /Volumes/esp/efi/refind`


2. In Terminal, navigate into the unzipped folder you downloaded from
SourceForge and copy the rEFInd files to the new rEFInd folder you just
created: <br> `sudo cp -r refind/* /Volumes/esp/efi/refind/`

<br>

## Remove Unnecessary rEFInd Files{#manualRemoveFiles}

There are several versions of rEFInd that were copied from the unzipped folder to the ESP folder, but you only need the one version that will work with your computer.

This step will show you how to remove the unnecessary versions of rEFInd from
`/Volumes/esp/efi/refind/`.

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
sudo rm /Volumes/esp/efi/refind/refind_x64.efi
```

<br>

## Rename rEFInd Config File{#manualModifyConfig}


If this is your first installation of rEFInd, rename the `refind.conf-sample` file to `refind.conf`:

```
sudo mv /Volumes/esp/efi/refind/refind.conf-sample /Volumes/esp/efi/refind/refind.conf
```

<br>

## Bless rEFInd {#manualBlessRefind}

The `bless` command makes a volume bootable. To bless this installation of rEFInd, enter:

```
sudo bless --mount /Volumes/esp --setBoot --file /Volumes/esp/efi/refind/refind_x64.efi --shortform
```

<br>

## Unmount the rEFInd directory {#manualUnmount}

You can restart your computer now and it will automatically unmount the ESP and run rEFInd after it restarts. If you want to unmount the ESP folder before you restart your computer, enter the following command:

```
diskutil unmount /dev/disk0s1
```
or

```
diskutil unmount /Volumes/esp
```

<br>

## Re-enable System Integrity Protection {#manualReenableSIP}

If you disabled System Integrity Protection (SIP), you should re-enable it
after you've finished installing rEFInd. Re-enabling System Integrity
Protection is almost identical to disabling it:

1. Restart your computer.
2. While it's restarting hold down Command-R (⌘R). This will start your computer in [Recovery mode](https://support.apple.com/en-us/HT201314).
3. Click on the **Utilities** menu and select **Terminal**.
4. Enter ```csrutil enable```.
5. Restart your computer normally.

<br>

## That's it

After restarting, your computer will load the rEFInd boot manager automatically. You will see a screen like the one below. Use the left and right arrows to select an operating system.

<img src="/portfolio/refind.png">

<br>
