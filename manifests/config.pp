# == Class hitch::config
#
# This class is called from hitch for service config.
#
class hitch::config {

  file { $::hitch::config_root:
    ensure  => directory,
    recurse => true,
    purge   => $::hitch::purge_config_root,
  }

  concat { $::hitch::config_file:
    ensure => present,
  }

  concat::fragment { "${title} config":
    content => template('hitch/hitch.conf.erb'),
    target  => $::hitch::config_file,
  }

  create_resources('hitch::domain', $::hitch::domains)
}
