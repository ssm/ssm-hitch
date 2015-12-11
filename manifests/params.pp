# == Class hitch::params
#
# This class is meant to be called from hitch.
# It sets variables according to platform.
#
class hitch::params {
  case $::osfamily {
    'Debian': {
      $package_name = 'hitch'
      $service_name = 'hitch'
    }
    'RedHat', 'Amazon': {
      $package_name = 'hitch'
      $service_name = 'hitch'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
