# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased] - 

### Added
- Add support for *Lucky* v0.27

### Changed
- Replace travis-ci with GitHub actions

### Removed
- Remove support for *Lucky* v0.26

## [0.8.0] - 2021-03-09

### Added
- Add support for *Lucky* v0.26.
- Add user option to send notification emails for new bearer logins.
- Add array support for enum adapters created with `.__enum` macro.

### Changed
- Require email columns to be case-insensitive.
- Save login notification option only when `Login` model is active.
- Rename `DeleteLogin` to `DeleteCurrentLogin`.
- Undo `skip_default_columns` in `Shield::AuthenticationColumns`

### Removed
- Remove support for *Lucky* v0.25.
- Remove `Shield::DeleteOperation` operation mixin.

## [0.7.0] - 2021-02-02

### Added
- Add presets, which sets most things up for you.
- Add `Shield::HttpClient` that enables API and browser authentication in tests.
- Add `Shield::FakeNestedParams` for creating params in tests.
- Add `Shield::BearerToken` utility
- Add `Shield::BearerScope` utility
- Add `Shield::PasswordResetUrl` utility
- Add `Shield::EmailConfirmationUrl` utility
- Add `Shield::BcryptHash` utility
- Add `Shield::Sha256Hash` utility
- Add `Shield::PasswordAuthentication` utility
- Add `Avram::NestedSaveOperation.has_one` macro
- Add `Shield::HasOneSaveUserOptions` operation mixin
- Add `Shield::SkipAuthenticationCache`
- Add `Shield::Api::SkipAuthenticationCache`
- Add `Avram::Validations.validate_primary_key`
- Add `Shield::SetUserIdFromUser` operation mixin
- Add `Shield::DeleteOperation` operation mixin.
- Add `Shield::StatusColumns` model mixin
- Add `Shield::StatusQuery` operation mixin
- Add `Shield::Activate` operation mixin
- Add `Shield::Deactivate` operation mixin

### Changed
- Rework delete operations to accept a record instead of record id.
- Rename `started_at` database columns to `active_at`
- Rename `ended_at` database columns `inactive_at`

### Fixed
- Improve brute force and timing attack mitigations.
- Fix email enumeration protection failure in password resets.
- Fix `Memoize` annotation not caching as intended.
- Fix `before_save` callbacks called multiple times in a single save.

### Removed
- Remove `Shield::BearerLoginHelper`
- Remove `Shield::CryptoHelper`
- Remove `Shield::EmailConfirmationHelper`
- Remove `Shield::LoginHelper`
- Remove `Shield::PasswordResetHelper`
- Remove `Shield::UserHelper`
- Remove `Avram::NestedSaveOperation.has_one_create` macro
- Remove `Avram::NestedSaveOperation.has_one_update` macro
- Remove `Shield::HasOneCreateSaveUserOptions` operation mixin
- Remove `Shield::HasOneUpdateSaveUserOptions` operation mixin
- Remove `Avram::Box.has_one` macro
- Remove `Avram::Validations.validate_exists_by_id`
- Remove default values from all operation `.needs` calls
- Remove `bcrypt_cost` setting

## [0.6.0] - 2020-12-21

### Added
- Add support for *Lucky* v0.25.0
- Add `Avram::Attribute#value!` that raises if value is `nil`.

### Changed
- Rename `Shield::AuthenticationQuery#active` to `#is_active`
- Reduce *Pwned Passwords* API retry times from 5 to 3

### Removed
- Drop support for *Lucky* versions lower than v0.25.0

## [0.5.1] - 2020-12-08

### Changed
- Undo automatic page reload when login times out

## [0.5.0] - 2020-12-01

### Added
- Integrate [*Pwned Passwords*](https://haveibeenpwned.com/Passwords)
- Add login idle timeout
- Validate the existence of records for foreign keys in save operations
- Add `Avram::Validations.validate_not_pwned`
- Add `Avram::Validations.validate_http_url`
- Add `Avram::Validations.validate_domain_label`
- Add `Avram::Validations.validate_slug`
- Add `Avram::Validations.validate_exists_by_id`
- Add `Avram::Validations.validate_positive_number`
- Add `Avram::Validations.validate_negative_number`
- Add `Shield::SetToken` operation mixin
- Add `Shield::AuthenticationColumns#inactive?`

### Changed
- Split action helpers and pipes into modules that may be used independently
- Rename `Avram::Validations.validate_subdomain` to `.validate_domain_label`
- Rename `bearer_login_id` attributes in basic operations to `id`
- Rename `email_confirmation_id` attributes in basic operations to `id`
- Rename `login_id` attributes in basic operations to `id`
- Rename `password_reset_id` attributes in basic operations to `id`
- Rename `user_id` attributes in basic operations to `id`
- Convert `Shield::DeleteSession(U)` to a non-generic `Shield::DeleteSession`

## [0.4.0] - 2020-11-12

> In memory of [*Flt. Lt. J. J. Rawlings*](https://en.wikipedia.org/wiki/Jerry_Rawlings), who passed away today. May his soul rest in peace.

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
