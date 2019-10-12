#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with hitch](#setup)
    * [What hitch affects](#what-hitch-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with hitch](#beginning-with-hitch)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module installs and configures the Hitch TLS proxy, and adds a
define to add domains.

## Module Description

This module installs the hitch package, and controls the hitch service
and the configuration file.

There is a defined type to add domains with key, certificate, as well
as an optional certificate chain and dh parameter.  The TLS files are
concatenated into one PEM file, and added to the configuration file.


## Setup

### What hitch affects

* Package "hitch"
* Service "hitch"
* Directory "/etc/hitch"
* Configuration file "/etc/hitch/hitch.conf"
* A PEM file inside /etc/hitch for each domain, with TLS key,
  certificate, ca certificate chain, and dh parameters.


### Setup Requirements

The module requires that the "hitch" package is available in a
reachable package repository.

* If osfamily is RedHat, the module adds the epel-release package with
  ensure_packages

* If osfamily is Debian, you are expected to provide a repository
  containing the "hitch" package.


### Beginning with hitch

To start using hitch, you need to include the hitch class, and add at
least one hitch::domain.

    include ::hitch
    hitch::domain { 'example.com':
      key_source  => '/tmp/key',
      cert_source => '/tmp/cert.pem',
    }

When configured with this module, hitch will listen by default on all
interfaces, port 443/TCP for both IPv4 and IPv6, and forward TCP
connections to localhost, port 80.


## Usage

When using hitch with varnish or nginx, one can provide information
about the connecting client, like the connecting IP Address and port,
to varnish by using the PROXY protocol.  The backend should be
configured with an additional listening port for this protocol.

    class { '::hitch':
      write_proxy_v2 => 'on',
      backend        => '[::1]:6086'
    }

In case of varnish, add an extra "-a" parameter for a separate
listening port:

    -a '[::1]:6086,PROXY'

…to have it listen on port 6086, using the PROXY protocol instead of
the HTTP protocol.

For more information about the PROXY protocol, see
http://www.haproxy.org/download/1.5/doc/proxy-protocol.txt


## Reference

### class: hitch

This class installs hitch, and manages the service and configuration
file.  To start, hitch requires at least one hitch::domain.

Parameters

* **frontend**: The listening port for hitch.  (optional, default is
  the https port)
* **ciphers**: The cipher list used for the encryption. (optional,
  default is strong ciphers with forward secrecy)

* **backend**: The address and port for the backend. (optional,
  default is the http port on the local host)
* **write_proxy_v2**: If set to "on", use the PROXY protocol instead
  of HTTP for the backend connection.  (optional, default "off")

* **package_name**: The name of the package to be installed (optional,
  default is osfamily specific)
* **service_name**: The name of the service (optional, default is
  osfamily specific)

* **file_owner**: The owner of the files and directories used to
  configure hitch. (optional, default "root")
* **config_file**: Path to the hitch configuration file (optional,
  default is "/etc/hitch/hitch.conf")
* **config_root**: Path to the root directory of the hitch
  configuration (optional, default is "/etc/hitch")
* **purge_config_root**: If true, remove all unknown files in the
  config_root (optional, default false)

* **dhparams_file**: Path the the dhparams file (optional, default is
  /etc/hitch/dhparams.pem)
* **dhparams_content**: A string containing the default dhparams used
  in all domain PEM files.  (optional. If not set, a dhparams file
  will be generated on the host.)

* **domains**: A hash used to create hitch::domain resources, for use
  with hiera. (optional, default {})

* **manage_repo**: If true, install installs the `epel-release`
  package on Red Hat OS family so Hitch can be installed. (optional,
  default true on RedHat, otherwise false)

### define: hitch::domain

Configure a domain in hitch.conf, and generate the PEM file used to
hold all the TLS keys, certificates and parameters.

Parameters

* **ensure**: set the desired state of the resource. (optional, valid
  values are absent or present, default is present)

One of **key_content** and **key_source** is required.

* **key_content**: a string containing the TLS key (no default)
* **key_source**: source to the TLS key, either a file, or a puppet
  uri (no default)

One of **cert_content** and **cert_source** is required.

* **cert_content**: a string containing the TLS certificate (no
  default)
* **cert_source**: source to the TLS certificate, either a file, or a
  puppet uri (no default)

No more than one of **cacert_content** and **cacert_source** must be
specified.

* **cacert_content**: a string containing the ca certificate chain
  (optional, no default)
* **cacert_source**: source to the ca certificate chain, either a
  file, or a puppet uri (optional, no default)

No more than one of **dhparams_content** and **dhparams_source** must
be specified.  If not specified, the dhparams of the **hitch** class
is used instead.

* **dhparams_content**: a string containing the ca certificate chain
  (optional, default is the dhparams of the hitch class)
* **dhparams_source**: source to the ca certificate chain, either a
  file, or a puppet uri (optional, default is the dhparams of the
  hitch class)

## Limitations

You need to define at least one `hitch::domain`, or the `hitch`
service will not start.

## Development

Please see CONTRIBUTING.md for contributing to the development of this
module.
