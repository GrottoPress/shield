# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased] - 

### Added
- Add *Bearer* authentication ([RFC 6750](https://tools.ietf.org/html/rfc6750)).
- Add documentation on integration with third-party authorization shards
- Add `Shield::DeleteSession` operation mixin
- Add `Shield::IpAddressColumn` model mixin

### Fixed
- Fix wrong flash type used when deleting user fails
- Fix `#redirect_back` going back past the previous page sometimes
- Fix other users logged out when a given user's password changes

### Changed
- Add `user : User` parameter to `Shield::AuthorizationPipes#authorize?`
- Return `403` status code, by default, for denied requests.
- Rename `Shield::Logins` to `Shield::CurrentLogin`

### Removed
- Remove `Shield::Error`
- Remove `Shield::Users` actions

## [0.3.0] - 2020-09-19

### Added
- Add support for *Lucky* v0.24.0
- Allow sending welcome emails
- Add `Shield::DeleteUser` operation
- Add `Shield::Users::Destroy` action
- Forward nested save operation errors to the parent operation

### Changed
- Add global `bcryp_cost` setting; defaults to `12`
- Add `salt : Bool` parameter to `Shield::CryptoHelper#hash_sha256`
- Rename the generated methods in `Avram::NestedSaveOperation`'s *has one* macros

### Removed
- Drop support for *Lucky* versions lower than v0.24.0
- Remove required `RegisterEmailConfirmationCurrentUser` and `UpdateEmailConfirmationCurrentUser`
- Remove `record` parameter from the generated nested operation method in `Avram::NestedSaveOperation.has_one_update`

### Fixed
- Fix user enumeration during user registration
- Fix flash messages not showing after a redirect

## [0.2.0] - 2020-08-29

### Added
- Add email confirmation
- Add support for return URL (a session value to redirect back to)

### Changed
- Introduce `Shield::Session` as base type for all session wrappers
- Improve previous page determination
- Rename `*_hash` columns to `*_digest`.

### Fixed
- Fix `#redirect_back` redirecting to login page
- Fix invalid HTTP date format for "Expires" header in `#disable_cache` action pipe

## [0.1.0] - 2020-08-15

### Added
- Initial public release
