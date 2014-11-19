# Author    :: Alok Jani (mailto: Alok.Jani@ril.com)
# Copyright :: Copyright (c) 2014 Reliance Jio Infocomm, Ltd
# License   :: Apache 2.0
#
# === Class: symantec_netbackup::installer
#
# This private class is meant to be called from `symantec_netbackup`.
# It installs the NetBackup Client
#

class symantec_netbackup::installer {
  if $caller_module_name != $module_name {
    fail ("Use of private class ${name} by ${caller_module_name}")
  }

  case $::osfamily {
      'windows': {
        $executable_7za     = $symantec_netbackup::executable_7za
        $local_archive      = $symantec_netbackup::setup_archive  # full path to zip file containing NB Client
        $extract_location   = $symantec_netbackup::archive_extract_to  # full path to directory where to extract & install from

        file { $extract_location :
          ensure  => directory,
        }
        ->
        # Extract the archive containing the NetBackup Client
        exec { 'extract_installer':
          cwd       =>  "${extract_location}",
          command   =>  "C:\Windows\System32\cmd.exe /c ${executable_7za} e ${local_archive} -o${extract_location} -y",
        }
 
        case $symantec_netbackup::ensure {
          'present': {
              file { "${extract_location}/silentinstall.cmd" :
                ensure      => file,
                content     => template('symantec_netbackup/silentinstall.cmd.erb'),
                require     => Exec['extract_installer']
              }  ->          
              exec { 'run_installer':
                cwd       =>  "${extract_location}",
                command   =>  "${extract_location}/silentinstall.cmd",
              }  -> 
              notify { 'post_install_run':
                message   =>  'Symantec NetBackup installation run complete.',
              }
          }

          'absent': {
              file { "${extract_location}/silentremove.cmd" :
                ensure      => file,
                content     => file('symantec_netbackup/silentuninstall.cmd'),
                require     => Exec['extract_installer']
              }  ->          
              exec { 'run_uninstaller':
                cwd      =>  "${extract_location}",
                command   =>  "${extract_location}/silentuninstall.cmd",
              }  -> 
              notify { 'post_remove_run':
                message   =>  'Symantec NetBackup Uninstalled.',
              }
          }
          default: {}
        }

    }

    default: {
      fail ('This module was build for Windows only.')
    }
  }

}

