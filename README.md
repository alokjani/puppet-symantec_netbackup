# symantec_netbackup

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with symantec_netbackup](#setup)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - module internals](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)

## Overview

The `symantec_netbackup` module allows you to manage the Symantec™ NetBackup Client install on Windows. 

## Module Description

The `symantec_netbackup` module installs the NetBackup client from a local copy of the archived client installer.
Below is the list of contents of the NB Client archive.

```bash
# unzip -l Netbackup_7_Client_x64.zip
Archive:  Netbackup_7_Client_x64.zip
  Length      Date    Time    Name
---------  ---------- -----   ----
     9968  2011-08-27 00:22   x64/Bkupinst.xsl
 39964847  2013-11-14 02:59   x64/Data1.cab
 49991723  2013-11-14 02:59   x64/Data2.cab
108222516  2013-11-14 03:00   x64/Data3.cab
 42739120  2013-11-14 02:59   x64/Data4.cab
  1232760  2013-11-14 02:45   x64/IFResDll.dll
       65  2010-09-24 23:33   x64/Install_Upgrade.dis
  2628472  2013-11-14 02:45   x64/Setup.exe
     5239  2012-06-05 00:25   x64/silentclient.cmd
     1325  2011-02-25 05:22   x64/silentuninstall.cmd
107270144  2013-11-14 03:00   x64/Symantec NetBackup Client.msi
  4138872  2013-11-14 02:45   x64/VxLogServer.exe
       33  2009-09-06 20:29   x64/VxSetup.ini
---------                     -------
356205084                     13 files
```

Configuration is done by first unpacking the archived client and running the custom built `silentinstall.cmd` file 
which seeds the installer setup.


## Setup

This module has no external dependencies. It consists of a single class. 
Parameters need to be specified as such :

```puppet
  class { symantec_netbackup :
#   ensure              => 'absent',
    setup_archive       => 'Z:/installers/NetBackup_7_Client/NetBackup_7_Client_x64.zip',
    archive_extract_to  => 'C:/temp/',
    executable_7za      => 'Z:/installers/7za.exe',
    master_server       => 'nb-master.example.lan',
    additional_servers  => 'nb-media1.example.lan, nb-media2.example.lan',
    install_dir         => 'C:\Program Files\VERITAS\\',
    vnetd_port          => 13724,
  }
```

## Usage

### Classes and Defined Types

#### Class: `symantec_netbackup`
This module manages the install/uninstall of the Symantec NetBackup Client for Windows.

**Parameters within `symantec_netbackup`:**
####`ensure`
Possible options are:           
* `present` activates the install and ensures that the NetBackup Services are running.
* `absent` will remove the NetBackup Client.
* `disable` turns of the NetBackup Services on the host

####`setup_archive`
The complete path to the Zip Archive containing the NetBackup Client. 

####`archive_extract_to`
The directory path into which to extract the NetBackup Client Zip Archive

####`executable_7za`
Full path to 7zip CLI binary (7za.exe)
 
####`master_server`
The central server that manages both the media servers and the clients

####`additional_servers`
A comma separated list of NetBackup Media servers

####`install_dir`
The directory where the NetBackup client gets installed. Defaults to `C:\Program Files\VERITAS`

####`vnetd_port`
Defaults to 13724


## Reference

### Classes
####Public Classes
* [`symantec_netbackup`]  : Installs the NetBackup package. Introduces fact `symantec_netbackup` on the system that returns current version if installed or `absent` is not present.

####Private Classes
* [`symantec_netbackup::installer`] :  Manages the install/uninstall of NetBackup
* [`symantec_netbackup::service`] : Ensures the required NetBackup Service state is maintained


## Limitations

This module was tested with:

* Symantec NetBackup version 7.6.0.1
* Windows Server 2012 Standard x64
* Puppet 3.7.2 (64-bit OSS version)

