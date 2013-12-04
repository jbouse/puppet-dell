# = Dell RACADM version facts
#
# == Resolution:
#
# Resolves the racadm_version fact and extracts the relevant substrings
#
Facter.add('racadm_version') do
  confine :is_dell_machine => true

  setcode do
    racadm_v = Facter::Util::Resolution.exec('/opt/dell/srvadmin/sbin/racadm version')
    racadm_version = racadm_v.scan(/^RACADM version\s+([\d.]+)\s+/m).flatten.last unless racadm_v.nil?
  end
end

{
  :racadm_major_version => /^(\d+)\.\d+\.\d+/,
  :racadm_minor_version => /^\d+\.(\d+)\.\d+/,
  :racadm_patch_version => /^\d+\.\d+\.(\d+)/,
}.each_pair do |fact_name, fact_regex|

  Facter.add(fact_name) do
    confine :is_dell_machine => true

    setcode do
      if Facter.value(:racadm_version) && Facter.value(:racadm_version).match(fact_regex)
        $1
      end
    end
  end
end
