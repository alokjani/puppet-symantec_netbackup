require 'facter'
pkg = Puppet::Type.type(:package).new(:name => "Symantec NetBackup Client")
v = pkg.retrieve[pkg.property(:ensure)].to_s
Facter.add(:symantec_netbackup) do
	confine :osfamily => :windows
  setcode do
		v 
  end
end
