# @summary
#   Manage the hitch TLS proxy
#
# @param package_name
#   Package name for installing hitch.
#
# @param service_name
#   Service name for the hitch service.
#
# @param user
#   User running the service.
#
# @param group
#   Group running the service.
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
#
# @param purge_config_root
#   If true, will delete all unmanaged files from the config_root.
#   Defaults to false.
#
# @param frontend
#   The listening frontend(s) for hitch.
#
# @param manage_repo
#    If true, install the EPEL repository on RedHat OS family.
#
class hitch (
  String $package_name,
  String $service_name,
  String $user,
  String $group,
  String $file_owner,
  Stdlib::Absolutepath $config_file,
  Stdlib::Absolutepath $dhparams_file,
  Stdlib::Absolutepath $config_root,
  Boolean $purge_config_root,
  Variant[String, Array] $frontend,
  String $backend,
  Enum['on', 'off'] $write_proxy_v2,
  String $ciphers,
  Optional[Hash] $domains,
  Optional[String] $dhparams_content,
  Boolean $manage_repo,
  Variant[Integer, Enum['auto']] $workers,
  Enum['on','off'] $prefer_server_ciphers,
  Optional[String] $alpn_protos,
  Optional[String] $tls_protos,
) {

  class { '::hitch::install':
    package     => $package_name,
    manage_repo => $manage_repo,
  }
  -> class { '::hitch::config':
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
  ~> class { '::hitch::service':
    service_name => $service_name,
  }
  -> Class['::hitch']

  $domains.each |$domain_title, $domain_params| {
    hitch::domain { $domain_title:
      * => $domain_params,
    }
  }
}
