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

  exec { "${title} generate dhparams":
    path    => '/usr/local/bin:/usr/bin:/bin',
    command => "openssl dhparam 2048 -out ${::hitch::dhparams_file}",
  }
  file { $::hitch::dhparams_file:
    owner => 'root',
    group => $::hitch::group,
    mode  => '0640',
  }

  concat::fragment { "${title} config":
    content => template('hitch/hitch.conf.erb'),
    target  => $::hitch::config_file,
  }

  create_resources('hitch::domain', $::hitch::domains)
}
