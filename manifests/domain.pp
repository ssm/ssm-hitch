# @summary
#   Add a TLS certificate and key for a domain
#
# This define installs pem files to the config root, and configures
# them in the hitch config file.
#
# The CA certificate (if present), server certificate, key and DH
# parameters are concatenated, and placed in the hitch configuration.
#
# You can specify cacert, cert and key with either _content or _source
# suffix.
#
# Parameters:
#
# @param ensure
#   The desired state of the hitch domain.  Default is 'present'.
#
# @param default
#   If there are multiple domains, set this to true to make this the
#   default domain used by hitch.  If there is only one domain, it
#   will be the default domain no matter what you set here. Defaults
#   to false.
#
# @param cacert_content
#   A PEM encoded CA certificate.
#
# @param cacert_source
#   Path to a PEM encoded CA certificate.
#
# @param cert_content
#   A PEM encoded certificate. This must be a certificate matching the
#   key.
#
# @param cert_source
#   Path to a PEM encoded certificate. This must be a certificate
#   matching the key.
#
# @param key_content
#   A PEM encoded key. This must be a key matching the certificate.
#
# @param key_source
#   Path to a PEM encoded key. This must be a key matching the
#   certificate.
#
define hitch::domain (
  Enum['present', 'absent'] $ensure = present,
  Boolean $default = false,
  Optional[String] $cert_content = undef,
  Optional[String] $key_content = undef,
  Optional[String] $cacert_content = undef,
  Optional[Stdlib::Filesource] $cert_source = undef,
  Optional[Stdlib::Filesource] $key_source = undef,
  Optional[Stdlib::Filesource] $cacert_source = undef,

)
{

  if ($key_content and $cert_content) {
    validate_x509_rsa_key_pair($cert_content, $key_content)
  }

  include ::hitch

  $config_root = $hitch::config_root
  $config_file = $hitch::config_file
  $dhparams_file = $hitch::dhparams_file
  $pem_file="${config_root}/${title}.pem"

  Concat::Fragment {
    notify  => Class['hitch::service'],
  }

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
    notify => Class['hitch::service'],
  }

  concat::fragment {"${title} key":
    target  => $pem_file,
    order   => '01',
    content => $key_content,
    source  => $key_source,
  }

  concat::fragment {"${title} cert":
    target  => $pem_file,
    order   => '02',
    content => $cert_content,
    source  => $cert_source,
  }

  if ($cacert_content or $cacert_source) {
    concat::fragment {"${title} cacert":
      target  => $pem_file,
      order   => '03',
      content => $cacert_content,
      source  => $cacert_source,
    }
  }

  concat::fragment {"${title} dhparams":
    target => $pem_file,
    source => $dhparams_file,
    order  => '04',
  }
}
