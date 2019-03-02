# == Class hitch::install
#
# This class is called from hitch for install.
#
class hitch::install (
  String $package,
) {

  if $::osfamily == 'RedHat' {
    ensure_resource('package', 'epel-release', { 'ensure' => 'present' })
    Package['epel-release'] -> Package[$package]
  }

  package { $package:
    ensure => present,
  }
}
