# == Class hitch::service
#
# This class is meant to be called from hitch.
# It ensure the service is running.
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
