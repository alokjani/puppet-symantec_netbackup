# Author    :: Alok Jani (mailto: Alok.Jani@ril.com)
# Copyright :: Copyright (c) 2014 Reliance Jio Infocomm, Ltd
# License   :: Apache 2.0
#
# == Class: symantec_netbackup
#
# This module manages the install/uninstall of the Symantec NetBackup Client for Windows.
#
# === Parameters
#
# [*ensure*]              
#   `present` activates the install and ensures that the NetBackup Services are running.
#   `absent` will remove the NetBackup Client.
#   `disable` turns of the NetBackup Services on the host
#
# [*setup_archive*]
#   The complete path to the Zip Archive containing the NetBackup Client. 
#   See README.md for more details
#      
# [*archive_extract_to*]
#   The directory path into which to extract the NetBackup Client Zip Archive
#
# [*executable_7za*]
#   Full path to 7zip CLI binary (7za.exe)
# 
# [*master_server*] 
#   The central server that manages both the media servers and the clients
#
# [*additional_servers*]
#   A comma separated list of NetBackup Media servers
#
# [*install_dir*]
#   The directory where the NetBackup client gets installed. Defaults to `C:\Program Files\VERITAS`
#
# [*vnetd_port *]
#   Defaults to 13724
#
# === Examples
#
#  class { symantec_netbackup :
#    ensure               => 'present',
#    setup_archive        => 'Z:/installers/NetBackup_7_Client/NetBackup_7_Client_x64.zip',
#    archive_extract_to   => 'C:/temp/',
#    executable_7za       => 'Z:/installers/7za.exe',
#    master_server        => '1.1.1.1',
#    additional_servers   => '1.1.1.2, 1.1.1.3',
#    install_dir          => 'C:\Program Files\VERITAS\\',
#    vnetd_port           => 13724,
#  }
#

class symantec_netbackup (
  $ensure               = $symantec_netbackup::params::ensure,
  $setup_archive        = $symantec_netbackup::params::setup_archive,
  $archive_extract_to   = $symantec_netbackup::params::archive_extract_to,
  $executable_7za       = $symantec_netbackup::params::executable_7za,
  $master_server        = $symantec_netbackup::params::master_server,
  $additional_servers   = $symantec_netbackup::params::additional_servers,
  $install_dir          = $symantec_netbackup::params::install_dir,
  $vnetd_port           = $symantec_netbackup::params::vnetd_port
) inherits symantec_netbackup::params {

  if $::operatingsystem != 'windows' {
    fail ('This OS is not tested yet !')
  }

  case $ensure {
    /(present)/: {
      if $::symantec_netbackup != 'absent' {
        notify { 'NetBackup_Service': name  =>  "Symantec NetBackup version [$::symantec_netbackup] found."}
        ->
        class { 'symantec_netbackup::service':}
      } else {
        notify { 'NetBackup_Installer': name  => 'Installing NetBackup.' }
        ->
        class { 'symantec_netbackup::installer': }
        ->
        class { 'symantec_netbackup::service': }
      }
    }

    /(absent)/: {
      if $::symantec_netbackup != 'absent' {
        notify { 'NetBackup_Installer': name  => "Ensuring Symantec NetBackup Client is not present." }
        ->
        class { 'symantec_netbackup::installer': } 
      } 
    }
    
    /(disable)/: {
      if $::symantec_netbackup != 'absent' {
        notify { 'NetBackup_Service':  message => 'Ensuring Symantec NetBackup is stopped.' }
        ->
        class { 'symantec_netbackup::service' : }
      }
    }

    default: {
      fail ('ensure parameter must be `present`, `absent` or `disable`')
    }
  }
}
