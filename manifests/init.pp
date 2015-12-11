# Class: hitch
# ===========================
#
# Full description of class hitch here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class hitch (
  $package_name = $::hitch::params::package_name,
  $service_name = $::hitch::params::service_name,
) inherits ::hitch::params {

  # validate parameters here

  class { '::hitch::install': } ->
  class { '::hitch::config': } ~>
  class { '::hitch::service': } ->
  Class['::hitch']
}
