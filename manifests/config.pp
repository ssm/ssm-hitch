# == Class hitch::config
#
# This class is called from hitch for service config.
#
# @api private
class hitch::config (
  Stdlib::Absolutepath $config_root,
  Stdlib::Absolutepath $config_file,
  Stdlib::Absolutepath $dhparams_file,
  Boolean $purge_config_root,
  String $file_owner,
  String $user,
  String $group,
  String $dhparams_content,
  String $write_proxy_v2,
  String $frontend,
  String $backend,
  String $ciphers,
) {

  file { $config_root:
    ensure  => directory,
    recurse => true,
    purge   => $purge_config_root,
    owner   => $file_owner,
    group   => $group,
    mode    => '0750',
  }

  concat { $config_file:
    ensure => present,
  }

  if $dhparams_content {
    file { $dhparams_file:
      ensure  => present,
      owner   => $file_owner,
      group   => $group,
      mode    => '0640',
      content => $dhparams_content,
    }
  }
  else {
    exec { "${title} generate dhparams":
      path    => '/usr/local/bin:/usr/bin:/bin',
      command => "openssl dhparam 2048 -out ${dhparams_file}",
      creates => $dhparams_file,
    }

    -> file { $dhparams_file:
      ensure => present,
      owner  => $file_owner,
      group  => $group,
      mode   => '0640',
    }
  }

  concat::fragment { "${title} config":
    content => template('hitch/hitch.conf.erb'),
    target  => $config_file,
  }

}
