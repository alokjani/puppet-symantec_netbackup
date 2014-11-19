# Author    :: Alok Jani (mailto: Alok.Jani@ril.com)
# Copyright :: Copyright (c) 2014 Reliance Jio Infocomm, Ltd
# License   :: Apache 2.0
#
# === Class: symantec_netbackup::params
#
# This private class is meant to be called from `symantec_netbackup`.
#

class symantec_netbackup::params {
  $ensure             = 'present'
  $setup_archive      = 'C:\installers\NetBackup_7_Client\NetBackup_7_Client_x64.zip'
  $archive_extract_to = 'C:/temp/'
  $executabe_7za      = 'C:/installers/7za.exe'
  $master_server      = 'nb-master.prod.example.tld'
  $additional_servers = 'nb-media1.prod.example.tld, nb-media2.prod.example.tld'
  $install_dir        = 'C:\Program Files\VERITAS\\'
  $vnetd_port         = 13724
}

