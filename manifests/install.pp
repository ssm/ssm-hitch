# == Class hitch::install
#
# This class is called from hitch for install.
#
class hitch::install {

  if $::osfamily == 'RedHat' {
    ensure_packages(['epel-release'])
    Package['epel-release'] -> Package[$::hitch::package_name]
  }

  package { $::hitch::package_name:
    ensure => present,
  }
}
