# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [unreleased]
### Changed
* Change parameter `hitch::frontend` to permit an array of strings in
  addition to a single string

### Added
* Add parameter `hitch::workers`
* Add parameter `hitch::prefer_server_ciphers`
* Add parameter `hitch::alpn_protos`
* Add parameter `hitch::tls_protos`

## [0.1.5] - 2019-10-22
### Fixed
- Fix generation of DH parameters (again).

### Added
- Add manage_repo parameter. Defaults to true on RedHat OS family,
  which will install the "epel-repo" package.

### Changed
- Update OS support metadata. Debian 9-10 and RedHat 7-8.
- Updated with PDK 1.14.0
- Depends on Puppet 4.10, puppetlabs/stdlib 4.12.0
- Module defaults are now in Hiera data
- Module parameters use Types for validation

## [0.1.4] - 2015-12-18
### Fixed
- bugfix: make sure intermediate ca certificates are correctly placed in bundle
- bugfix: make sure dh parameters are created
- bugfix: notify service if pem files change

## [0.1.3] - 2015-12-18
### Fixed
- bugfix: using multiple pem-files failed.  Tests added.

## [0.1.2] - 2015-12-18
### Fixed
- relax too-strict validation of strings containing keys and certificates

## [0.1.1] - 2015-12-11
### Fixed
- fix versioned dependency on puppetlabs-stdlib in metadata
- fix documentation errors and nits

## [0.1.0] - 2015-12-11
### Added
- initial release

[unreleased]: https://github.com/ssm/ssm-hitch/compare/0.1.5...main
[0.1.5]: https://github.com/ssm/ssm-hitch/compare/0.1.4...0.1.5
[0.1.4]: https://github.com/ssm/ssm-hitch/compare/0.1.3...0.1.4
[0.1.3]: https://github.com/ssm/ssm-hitch/compare/0.1.2...0.1.3
[0.1.2]: https://github.com/ssm/ssm-hitch/compare/0.1.1...0.1.2
[0.1.1]: https://github.com/ssm/ssm-hitch/compare/0.1.0...0.1.1
[0.1.0]: https://github.com/ssm/ssm-hitch/commits/0.1.0
