# == Class: dell::openmanage
#
# Install openmanage tools
#
class dell::openmanage {

  include ::dell::hwtools

  service { 'dataeng':
    ensure    => running,
    hasstatus => true,
    require   => Package['srvadmin-all'],
  }

  service { 'dsm_om_connsvc':
    ensure    => running,
    hasstatus => true,
    require   => Package['srvadmin-all'],
  }

  service { 'dsm_om_shrsvc':
    ensure    => running,
    hasstatus => true,
    require   => Package['srvadmin-all'],
  }

  service { 'dsm_sa_ipmi':
    ensure    => running,
    hasstatus => true,
    require   => Package['srvadmin-all'],
  }

  file { '/etc/logrotate.d/openmanage':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => '# file managed by puppet
/var/log/TTY_*.log {
  missingok
  weekly
  notifempty
  compress
}
',
  }

  file { '/etc/logrotate.d/perc5logs': ensure  => absent }

  case $::osfamily {
    Redhat: {

      # openmanage is a mess to install on redhat, and recent versions
      # don't support older hardware. So puppet will install it if absent,
      # or else leave it unmanaged.
      include ::dell::openmanage::redhat

      augeas { 'disable dell yum plugin once OM is installed':
        changes => [
          'set /files/etc/yum/pluginconf.d/dellsysidplugin.conf/main/enabled 0',
          'set /files/etc/yum/pluginconf.d/dellsysid.conf/main/enabled 0',
        ],
        require => Service['dataeng'],
      }

    }

    Debian: {
      include ::dell::openmanage::debian
    }

    default: {
      err("Unsupported operatingsystem family: ${::osfamily}.")
    }

  }

}
