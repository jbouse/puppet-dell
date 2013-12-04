# == Class: dell::params
#
# Parameters
# TODO: remove lenny and refactor this
#
class dell::params (
  $dell_omsa_url_base           = '',
  $dell_omsa_url_args_indep     = '',
  $dell_omsa_url_args_specific  = '',
  $dell_omsa_version            = '',
  $dell_customplugins           = '',
  $dell_check_warranty_revision = '',
) {

  case $::osfamily {
    'RedHat': {
      $omsa_url_base = $dell_omsa_url_base ? {
        ''      => 'http://linux.dell.com/repo/hardware/',
        default => $dell_omsa_url_base,
      }

      $omsa_url_args_indep = $dell_omsa_url_args_indep ? {
        ''      => 'osname=el$releasever&basearch=$basearch&native=1&dellsysidpluginver=$dellsysidpluginver',
        default => $dell_omsa_url_args_indep,
      }

      $omsa_url_args_specific = $dell_omsa_url_args_specific ? {
        ''      => 'osname=el$releasever&basearch=$basearch&native=1&sys_ven_id=$sys_ven_id&sys_dev_id=$sys_dev_id&dellsysidpluginver=$dellsysidpluginver',
        default => $dell_omsa_url_args_specific,
      }
    }

    'Debian': {
      case $::lsbmajdistrelease {
        '7': {
          $omsa_url_base = $dell_omsa_url_base ? {
            ''      => 'http://linux.dell.com/repo/community/debian/',
            default => $dell_omsa_url_base,
          }
        }

        default: {
          $omsa_url_base = $dell_omsa_url_base ? {
            ''      => 'http://linux.dell.com/repo/community/deb/',
            default => $dell_omsa_url_base,
          }
        }
      }

      $smbios_pkg = $::lsbdistcodename ? {
        'lenny' => 'libsmbios-bin',
        default => 'smbios-utils',
      }
    }

    default:  { fail("Unsupported OS family: ${::osfamily}") }
  }

  $omsa_version = $dell_omsa_version ? {
    ''       => 'latest',
    'latest' => 'latest',
    default  => "OMSA_${dell_omsa_version}",
  }

  $customplugins = $dell_customplugins ? {
    ''      => '/usr/local/src',
    default => $dell_customplugins,
  }

  $check_warranty_revision = $dell_check_warranty_revision ? {
    ''      => '42d157c57b1247e651021098b278adf14e468805',
    default => $dell_check_warranty_revision,
  }
}
