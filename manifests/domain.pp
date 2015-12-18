# == Define hitch::domain
#
# This define installs pem files to the config root, and configures
# them in the hitch config file
#
define hitch::domain (
  $ensure           = present,
  $cacert_content   = undef,
  $cacert_source    = undef,
  $cert_content     = undef,
  $cert_source      = undef,
  $dhparams_content = undef,
  $dhparams_source  = undef,
  $key_content      = undef,
  $key_source       = undef,
)
{

  # Parameter validation

  validate_re($ensure, ['^present$', '^absent$'])

  # Exactly one of $key_source and $key_content
  if ($key_content and $key_source) or (! $key_content and ! $key_source) {
    fail("Hitch::Domain[${title}]: Please provide key_source or key_domain")
  }
  if $key_content {
    validate_re($key_content, 'PRIVATE KEY')
  }

  # Exactly one of $cert_content and $cert_source
  if ($cert_content and $cert_source) or (!$cert_content and !$cert_source) {
    fail("Hitch::Domain[${title}]: Please provide cert_source or cert_domain")
  }
  if $cert_content {
    validate_re($cert_content, 'CERTIFICATE')
  }

  # One or zero of $cacert_content or $cacert_source
  if ($cacert_content and $cacert_source) {
    fail("Hitch::Domain[${title}]: Please do not specify both cacert_source and cacert_domain")
  }
  if $cacert_content {
    validate_re($cacert_content, 'CERTIFICATE')
  }

  # One of $dhparams_content or $dhparams_source, with fallback to
  # $::hitch::dhparams_file
  if ($dhparams_content and $dhparams_source) {
    fail("Hitch::Domain[${title}]: Please do not specify both dhparams_source and dhparams_domain")
  }
  if $dhparams_content {
    validate_re($dhparams_content, 'DH PARAMETERS')
  }


  include ::hitch
  include ::hitch::config

  $config_file = $::hitch::config_file
  validate_absolute_path($config_file)

  $pem_file="${::hitch::config_root}/${title}.pem"
  validate_absolute_path($pem_file)


  # Add a line to the hitch config file
  concat::fragment { "hitch::domain ${title}":
    target  => $config_file,
    content => "pem-file = \"${pem_file}\"\n",
  }

  # Create the pem file, with (optional) ca certificate chain, a
  # certificate, a key, and finally the dh parameters
  concat { $pem_file:
    ensure => $ensure,
    mode   => '0640',
    owner  => $::hitch::file_owner,
    group  => $::hitch::group,
  }

  concat::fragment {"${title} key":
    content => "${key_content}\n",
    source  => $key_source,
    target  => $pem_file,
    order   => '01',
  }

  concat::fragment {"${title} cert":
    content => "${cert_content}\n",
    source  => $cert_source,
    target  => $pem_file,
    order   => '02',
  }

  if ($cacert_content or $cacert_source) {
    concat::fragment {"${title} cacert":
      content => "${cacert_content}\n",
      source  => $cacert_source,
      target  => $pem_file,
      order   => '03',
    }
  }

  if ! $dhparams_content {
    if $dhparams_source {
      $_dhparams_source = $dhparams_source
    }
    else {
      $_dhparams_source = $::hitch::dhparams_file
      File[$::hitch::dhparams_file] -> Concat::Fragment["${title} dhparams"]
    }
  }

  if ($dhparams_content or $_dhparams_source) {
    concat::fragment {"${title} dhparams":
      content => "${dhparams_content}",
      source  => $_dhparams_source,
      target  => $pem_file,
      order   => '04',
    }
  }
}
