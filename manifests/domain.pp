# == Define hitch::domain
#
# This define installs pem files to the config root, and configures
# them in the hitch config file
#
define hitch::domain (
  $key,
  $cert,
  $ensure      = present,
  $cacert      = undef,
  $dhparams    = undef,
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

  # Create the pem file, with (optional) ca certificate chain, a
  # certificate, a key, and finally the dh parameters
  concat { $pem_file:
    ensure => $ensure,
    mode   => '0640',
    owner  => $::hitch::file_owner,
    group  => $::hitch::group,
  }

  if $cacert {
    concat::fragment {"${title} cacert":
      content => $cacert,
      target  => $pem_file,
      order   => '01',
    }
  }

  concat::fragment {"${title} cert":
    content => $cert,
    target  => $pem_file,
    order   => '02',
  }

  concat::fragment {"${title} key":
    content => $key,
    target  => $pem_file,
    order   => '03',
  }

  if $dhparams {
    concat::fragment {"${title} dhparams":
      content => $dhparams,
      target  => $pem_file,
      order   => '04',
    }
  }
  else {
    concat::fragment {"${title} dhparams":
      source => $::hitch::dhparams_file,
      target => $pem_file,
      order  => '04',
    }
  }
  
}
