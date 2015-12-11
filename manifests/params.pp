# == Class hitch::params
#
# This class is meant to be called from hitch.
# It sets variables according to platform.
#
class hitch::params {

  $config_root           = '/etc/hitch'
  $config_file           = '/etc/hitch/hitch.conf'
  $dhparams_file         = '/etc/hitch/dhparams.pem'
  $purge_config_root     = false
  $file_owner            = 'root'

  $frontend              = '[*]:443'
  $backend               = '[::1]:80'
  $write_proxy_v2        = 'off'
  $ciphers               = 'EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH'
  $prefer_server_ciphers = 'on'
  $domains               = {}

  case $::osfamily {
    'Debian': {
      $package_name = 'hitch'
      $service_name = 'hitch'
      $user         = '_hitch'
      $group        = '_hitch'
    }
    'RedHat', 'Amazon': {
      $package_name = 'hitch'
      $service_name = 'hitch'
      $user         = 'hitch'
      $group        = 'hitch'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
