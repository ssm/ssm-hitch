# @summary
#  Manage the hitch package and optionally a repository
#
# @api private
class hitch::install (
  String $package,
  Boolean $manage_repo,
) {
  if $manage_repo {
    if $facts['os']['family'] == 'RedHat' {
      ensure_resource('package', 'epel-release', { 'ensure' => 'present' })
      Package['epel-release'] -> Package[$package]
    }
  }

  package { $package:
    ensure => present,
  }
}
