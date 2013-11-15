output = Facter::Util::Resolution.exec('/opt/dell/srvadmin/sbin/racadm getconfig -g cfgLanNetworking')

{
  :drac_enabled    => /cfgNicEnable=(\d+)/,
  :drac_address    => /cfgNicIpAddress=(\S+)/,
  :drac_macaddress => /cfgNicMacAddress=(\S+)/,
  :drac_netmask    => /cfgNicNetmask=(\S+)/,
  :drac_gateway    => /cfgNicGateway=(\S+)/,
  :drac_name       => /cfgDNSRacName=(\S+)/,
}.each_pair do |fact_name, fact_regex|

  Facter.add(fact_name) do
    confine :is_dell_machine => true

    setcode do
      if output
        lines = output.split("\n")
        next "#{$1}"  if lines.any? {|l| l =~ fact_regex }
      end
    end
  end
end
