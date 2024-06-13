# @summary
#   Manage the hitch configuration, systemd configuration and default DH parameters.
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
  Enum['on','off'] $write_proxy_v2,
  Variant[String, Array] $frontend,
  String $backend,
  String $ciphers,
  Variant[Integer, Enum['auto']] $workers,
  Enum['on','off'] $prefer_server_ciphers,
  Optional[String] $dhparams_content = undef,
  Optional[String] $alpn_protos = undef,
  Optional[String] $tls_protos = undef,
) {
  case $frontend {
    Array: {
      $frontend_array = $frontend
    }
    String: {
      $frontend_string = $frontend
    }
    default: {
      fail('invalid frontend')
    }
  }

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
      ensure  => file,
      owner   => $file_owner,
      group   => $group,
      mode    => '0640',
      content => $dhparams_content,
    }
  }
  else {
    exec { "${title} generate dhparams":
      path    => '/usr/local/bin:/usr/bin:/bin',
      command => "openssl dhparam -out ${dhparams_file} 2048",
      creates => $dhparams_file,
    }

    -> file { $dhparams_file:
      ensure => file,
      owner  => $file_owner,
      group  => $group,
      mode   => '0640',
    }
  }

  $hitch_conf_params = {
    'user'                  => $user,
    'group'                 => $group,
    'frontend'              => $frontend,
    'backend'               => $backend,
    'workers'               => $workers,
    'write_proxy_v2'        => $write_proxy_v2,
    'alpn_protos'           => $alpn_protos,
    'tls_protos'            => $tls_protos,
    'ciphers'               => $ciphers,
    'prefer_server_ciphers' => $prefer_server_ciphers,
  }
  concat::fragment { "${title} config":
    content => epp('hitch/hitch.conf.epp', $hitch_conf_params ),
    target  => $config_file,
  }
}
