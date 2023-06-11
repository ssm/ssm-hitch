# @summary
#   Manage the hitch TLS proxy
#
# @example defaults
#   include hitch
#
#   hitch::domain { 'example.com':
#     cacert_source => '/etc/pki/tls/certs/ca.pem',
#     cert_source   => '/etc/pki/tls/certs/example.com.pem',
#     key_source    => '/etc/pki/tls/private_keys/example.com.pem',
#   }
#
# @param package_name
#   Package name for installing hitch.
#
# @param service_name
#   Service name for the hitch service.
#
# @param user
#   User running the service. Defaults vary by OS, see module hieradata.
#
# @param group
#   Group running the service. Defaults vary by OS, see module hieradata.
#
# @param backend
#   Where to proxy requests.
#
# @param config_file
#   Path to the hitch configuration file.
#
# @param file_owner
#   User owning the configuration files. Defaults to "root".
#
# @param dhparams_file
#   Path to file for Diffie-Hellman parameters, which are shared
#   by all domains.
#
# @param dhparams_content
#   Content for the DH parameter file.  If unset, DH parameters will
#   be generated on the node, which may take a long time.
#
# @param config_root
#   Configuration root directory. The hitch::domain defined type
#   will place certificates here.
#
# @param purge_config_root
#   If true, will delete all unmanaged files from the config_root.
#   Defaults to false.
#
# @param frontend
#   The listening frontend(s) for hitch.
#
# @param manage_repo
#    If true, install the EPEL repository on RedHat OS family. Defaults vary by OS, see module hieradata.
#
class hitch (
  String $user = 'hitch',
  String $group = 'hitch',
  String $package_name = 'hitch',
  String $service_name = 'hitch.service',
  String $file_owner = 'root',
  Stdlib::Absolutepath $config_file = '/etc/hitch/hitch.conf',
  Stdlib::Absolutepath $dhparams_file = '/etc/hitch/dhparams.pem',
  Stdlib::Absolutepath $config_root = '/etc/hitch',
  Boolean $purge_config_root = false,
  Variant[String, Array] $frontend = '[*]:443',
  String $backend = '[::1]:80',
  Enum['on', 'off'] $write_proxy_v2 = 'off',
  String $ciphers = 'EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH',
  Optional[Hash] $domains = {},
  Optional[String] $dhparams_content = undef,
  Boolean $manage_repo = false,
  Variant[Integer, Enum['auto']] $workers = 'auto',
  Enum['on','off'] $prefer_server_ciphers = 'on',
  Optional[String] $alpn_protos = 'http/1.1',
  Optional[String] $tls_protos = undef,
) {
  class { 'hitch::install':
    package     => $package_name,
    manage_repo => $manage_repo,
  }

  class { 'hitch::config':
    config_root           => $config_root,
    config_file           => $config_file,
    dhparams_file         => $dhparams_file,
    dhparams_content      => $dhparams_content,
    purge_config_root     => $purge_config_root,
    file_owner            => $file_owner,
    user                  => $user,
    group                 => $group,
    frontend              => $frontend,
    backend               => $backend,
    write_proxy_v2        => $write_proxy_v2,
    ciphers               => $ciphers,
    workers               => $workers,
    prefer_server_ciphers => $prefer_server_ciphers,
    alpn_protos           => $alpn_protos,
    tls_protos            => $tls_protos,
  }

  class { 'hitch::service':
    service_name => $service_name,
  }

  Class['hitch::install'] -> Class['hitch::config']
  Class['hitch::config'] ~> Class['hitch::service']

  $domains.each |$domain_title, $domain_params| {
    hitch::domain { $domain_title:
      notify => Class['hitch::service'],
      *      => $domain_params,
    }
  }
}
