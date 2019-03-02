# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [unreleased]
### Changed
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
