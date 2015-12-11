# Class: hitch
# ===========================
#
# Full description of class hitch here.
#
# Parameters
# ----------
#
# * `package_name`
#   Package name for installing hitch
#
# * `service_name`
#   Service name for the hitch service
#
# * `config_file`
#   Configuration file. Default: /etc/hitch/hitch.conf
#
# * `config_root`
#   Configuration root directory. Default: /etc/hitch/
class hitch (
  $package_name      = $::hitch::params::package_name,
  $service_name      = $::hitch::params::service_name,
  $file_owner        = $::hitch::params::file_owner,
  $config_file       = $::hitch::params::config_file,
  $dhparams_file     = $::hitch::params::dhparams_file,
  $dhparams          = $::hitch::params::dhparams,
  $config_root       = $::hitch::params::config_root,
  $purge_config_root = $::hitch::params::purge_config_root,
  $frontend          = $::hitch::params::frontend,
  $backend           = $::hitch::params::backend,
  $write_proxy_v2    = $::hitch::params::write_proxy_v2,
  $ciphers           = $::hitch::params::ciphers,
  $domains           = $::hitch::params::domains,
) inherits ::hitch::params {

  # validate parameters here

  class { '::hitch::install': } ->
  class { '::hitch::config': } ~>
  class { '::hitch::service': } ->
  Class['::hitch']
}
