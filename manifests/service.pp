# Author    :: Alok Jani (mailto: Alok.Jani@ril.com)
# Copyright :: Copyright (c) 2014 Reliance Jio Infocomm, Ltd
# License   :: Apache 2.0
#
# === Class: symantec_netbackup::service
#
# This private class is meant to be called from `symantec_netbackup`.
# It maintains the service state.
#

class symantec_netbackup::service {
  case $symantec_netbackup::ensure {
    'present': {
      service { 'NetBackup Discovery Framework':    ensure  => running,   enable  =>  true, } 
      service { 'NetBackup Legacy Client Service':  ensure  => running,   enable  =>  true, } -> 
      service { 'NetBackup Client Service':         ensure  => running,   enable  =>  true, } 
      service { 'NetBackup Legacy Network Service': ensure  => running,   enable  =>  true, } 
    } 

    'disable': {
      service { 'NetBackup Client Service':         ensure  => stopped,   enable  =>  true, } ->
      service { 'NetBackup Legacy Client Service':  ensure  => stopped,   enable  =>  true, } 
      service { 'NetBackup Discovery Framework':    ensure  => stopped,   enable  =>  true, } 
      service { 'NetBackup Legacy Network Service': ensure  => stopped,   enable  =>  true, } 
 
    }

    default : {}

  }
 
}
