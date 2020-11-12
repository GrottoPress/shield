# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [0.4.0] - 2020-11-12

> In memory of [*Flt. Lt. J. J. Rawlings*](https://en.wikipedia.org/wiki/Jerry_Rawlings), who passed away today. May his soul rest in perfect peace.

### Added
- Add *Bearer* authentication ([RFC 6750](https://tools.ietf.org/html/rfc6750)).
- Add more *Avram* validation helpers
- Add documentation on integration with third-party authorization shards
- Add `Shield::SetSession` and `Shield::DeleteSession` operation mixins
- Add `Shield::IpAddressColumn` model mixin
- Add `Shield::NotifyLogin` operation mixin
- Add `Shield::NotifyPasswordChange` operation mixin
- Add `Shield::HasManyBearerLogins` model association mixin
- Add `Shield::HasManyLogins` model association mixin
- Add `Shield::HasManyPasswordResets` model association mixin
- Add `Shield::HasOneUserOptions` model association mixin
- Add `Shield::BelongsToUser` model association mixin
- Add `Shield::HasOneCreateSaveUserOptions` and `Shield::HasOneUpdateSaveUserOptions` operation mixins
- Add `Shield::NeverExpires` operation mixin
- Add modules to delete authentication records, as an alternative to revoking them.

### Fixed
- Fix wrong flash type used when deleting user fails
- Fix `#redirect_back` going back past the previous page sometimes
- Fix other users logged out when a given user's password changes

### Changed
- Convert email confirmation into a database model
- Upgrade default hash for message encryptor/verifier from `SHA1` to `SHA256`
- Add `user : User` parameter to `Shield::AuthorizationPipes#authorize?`
- Return `403` status code, by default, for denied requests.
- Rename `Shield::Logins` to `Shield::CurrentLogin`
- Convert `EmailConfirmation#url` to a class method.
- Remove required `id` param from password reset URL.
- Remove the second parameter from all `#do_run_operation_failed` action methods.
- In development and test, automatically *click* email confirmation and password reset links.

### Removed
- Remove `password_confirmation` fields
- Remove `status` column from authentication models
- Remove `Shield::Error`

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
