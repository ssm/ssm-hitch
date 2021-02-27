#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with hitch](#setup)
    * [What hitch affects](#what-hitch-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with hitch](#beginning-with-hitch)
4. [Usage - Configuration options and additional functionality](#usage)
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

The module is documented in the REFERENCE.md file.

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


## Limitations

You need to define at least one `hitch::domain`, or the `hitch`
service will not start.

## Development

Issues and pull requests welcome.