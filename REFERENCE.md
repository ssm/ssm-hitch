# Reference

<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

### Classes

#### Public Classes

* [`hitch`](#hitch): Manage the hitch TLS proxy

#### Private Classes

* `hitch::config`: Manage the hitch configuration, systemd configuration and default DH parameters.
* `hitch::install`: Manage the hitch package and optionally a repository
* `hitch::service`: Manage the hitch service

### Defined types

* [`hitch::domain`](#hitchdomain): Add a TLS certificate and key for a domain

## Classes

### `hitch`

Manage the hitch TLS proxy

#### Examples

##### defaults

```puppet
include hitch

hitch::domain { 'example.com':
  cacert_source => '/etc/pki/tls/certs/ca.pem',
  cert_source   => '/etc/pki/tls/certs/example.com.pem',
  key_source    => '/etc/pki/tls/private_keys/example.com.pem',
}
```

#### Parameters

The following parameters are available in the `hitch` class.

##### `package_name`

Data type: `String`

Package name for installing hitch.

Default value: `'hitch'`

##### `service_name`

Data type: `String`

Service name for the hitch service.

Default value: `'hitch.service'`

##### `user`

Data type: `String`

User running the service. Defaults vary by OS, see module hieradata.

Default value: `'hitch'`

##### `group`

Data type: `String`

Group running the service. Defaults vary by OS, see module hieradata.

Default value: `'hitch'`

##### `backend`

Data type: `String`

Where to proxy requests.

Default value: `'[::1]:80'`

##### `config_file`

Data type: `Stdlib::Absolutepath`

Path to the hitch configuration file.

Default value: `'/etc/hitch/hitch.conf'`

##### `file_owner`

Data type: `String`

User owning the configuration files. Defaults to "root".

Default value: `'root'`

##### `dhparams_file`

Data type: `Stdlib::Absolutepath`

Path to file for Diffie-Hellman parameters, which are shared
by all domains.

Default value: `'/etc/hitch/dhparams.pem'`

##### `dhparams_content`

Data type: `Optional[String]`

Content for the DH parameter file.  If unset, DH parameters will
be generated on the node, which may take a long time.

Default value: ``undef``

##### `config_root`

Data type: `Stdlib::Absolutepath`

Configuration root directory. The hitch::domain defined type
will place certificates here.

Default value: `'/etc/hitch'`

##### `purge_config_root`

Data type: `Boolean`

If true, will delete all unmanaged files from the config_root.
Defaults to false.

Default value: ``false``

##### `frontend`

Data type: `Variant[String, Array]`

The listening frontend(s) for hitch.

Default value: `'[*]:443'`

##### `manage_repo`

Data type: `Boolean`

If true, install the EPEL repository on RedHat OS family. Defaults vary by OS, see module hieradata.

Default value: ``false``

##### `write_proxy_v2`

Data type: `Enum['on', 'off']`



Default value: `'off'`

##### `ciphers`

Data type: `String`



Default value: `'EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH'`

##### `domains`

Data type: `Optional[Hash]`



Default value: `{}`

##### `workers`

Data type: `Variant[Integer, Enum['auto']]`



Default value: `'auto'`

##### `prefer_server_ciphers`

Data type: `Enum['on','off']`



Default value: `'on'`

##### `alpn_protos`

Data type: `Optional[String]`



Default value: `'http/1.1'`

##### `tls_protos`

Data type: `Optional[String]`



Default value: ``undef``

## Defined types

### `hitch::domain`

This define installs pem files to the config root, and configures
them in the hitch config file.

The CA certificate (if present), server certificate, key and DH
parameters are concatenated, and placed in the hitch configuration.

You can specify cacert, cert and key with either _content or _source
suffix.

#### Examples

##### website with TLS files from managed node

```puppet
hitch::domain { 'example.com':
  cacert_source => '/etc/pki/tls/certs/ca.pem',
  cert_source   => '/etc/pki/tls/certs/example.com.pem',
  key_source    => '/etc/pki/tls/private_keys/example.com.pem',
}
```

##### website with TLS content from hiera

```puppet
class profile::hitch (
   Hash $domains = {},
) {
  $domains.each |$domain_title, $domain_params| {
    hitch::domain { $domain_title:
      * => $domain_params,
    }
  }
}
```

#### Parameters

The following parameters are available in the `hitch::domain` defined type.

##### `ensure`

Data type: `Enum['present', 'absent']`

The desired state of the hitch domain.  Default is 'present'.

Default value: `present`

##### `default`

Data type: `Boolean`

If there are multiple domains, set this to true to make this the
default domain used by hitch.  If there is only one domain, it
will be the default domain no matter what you set here. Defaults
to false.

Default value: ``false``

##### `cacert_content`

Data type: `Optional[String]`

A PEM encoded CA certificate.

Default value: ``undef``

##### `cacert_source`

Data type: `Optional[Stdlib::Filesource]`

Path to a PEM encoded CA certificate.

Default value: ``undef``

##### `cert_content`

Data type: `Optional[String]`

A PEM encoded certificate. This must be a certificate matching the
key.

Default value: ``undef``

##### `cert_source`

Data type: `Optional[Stdlib::Filesource]`

Path to a PEM encoded certificate. This must be a certificate
matching the key.

Default value: ``undef``

##### `key_content`

Data type: `Optional[String]`

A PEM encoded key. This must be a key matching the certificate.

Default value: ``undef``

##### `key_source`

Data type: `Optional[Stdlib::Filesource]`

Path to a PEM encoded key. This must be a key matching the
certificate.

Default value: ``undef``

