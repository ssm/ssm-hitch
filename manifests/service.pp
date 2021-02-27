# @summary
#  Manage the hitch service
#
# @api private
class hitch::service (
  String $service_name,
) {

  service { $service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  # configure hitch.service
  systemd::dropin_file { 'limits.conf':
    unit    => 'hitch.service',
    content => template('hitch/limits.conf.erb'),
  }
}
