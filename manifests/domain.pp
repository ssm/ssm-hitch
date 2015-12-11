# == Define hitch::domain
#
# This define installs pem files to the config root, and configures
# them in the hitch config file
#
define hitch::domain (
  $key,
  $cert,
  $ensure      = present,
  $cacert      = '',
  $dhparams    = '',
)
{

  include ::hitch
  include ::hitch::config

  $config_file = $::hitch::config_file
  validate_absolute_path($config_file)

  $pem_file="${::hitch::config_root}/${title}.pem"
  validate_absolute_path($pem_file)

  validate_re($key, 'BEGIN PRIVATE KEY')
  validate_re($cert, 'BEGIN CERTIFICATE')
  if $cacert {
    validate_re($cacert, 'BEGIN CERTIFICATE')
  }
  if $dhparams {
    validate_re($dhparams, 'BEGIN DH PARAMETERS')
  }

  validate_re($ensure, ['^present$', '^absent$'])
  # Add a line to the hitch config file
  concat::fragment { "hitch::domain ${title}":
    target  => $config_file,
    content => "pem-file = \"${pem_file}\"",
  }

  file { "/etc/hitch/${title}.pem":
    ensure  => $ensure,
    mode    => '0600',
    owner   => $::hitch::user,
    group   => $::hitch::group,
    content => "${cacert}\n${cert}\n${key}\n${dhparams}",
  }

}
