# == Class hitch::service
#
# This class is meant to be called from hitch.
# It ensure the service is running.
#
class hitch::service (
  String $service_name,
) {

  service { $service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
