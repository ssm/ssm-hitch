# == Class hitch::install
#
# This class is called from hitch for install.
#
class hitch::install {

  package { $::hitch::package_name:
    ensure => present,
  }
}
