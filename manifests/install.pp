# == Class hitch::install
#
# This class is called from hitch for install.
#
class hitch::install (
  String $package,
) {

  if $::osfamily == 'RedHat' {
    ensure_packages(['epel-release'])
    Package['epel-release'] -> Package[$package]
  }

  package { $package:
    ensure => present,
  }
}
