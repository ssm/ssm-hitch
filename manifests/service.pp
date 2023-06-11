# @summary
#  Manage the hitch service
#
# @api private
class hitch::service (
  String $service_name,
) {
  service { $service_name:
    ensure => running,
    enable => true,
  }

  # configure hitch.service
  $hitch_dropin = @(LIMITS)
      [Service]
  LimitNOFILE=65536
  | LIMITS

  systemd::dropin_file { 'limits.conf':
    unit    => $service_name,
    content => $hitch_dropin,
    notify  => Service[$service_name],
  }
}
