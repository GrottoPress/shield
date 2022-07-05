# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased] - 

### Added
- Add `Shield::BearerToken#bearer_login`
- Add `Shield::BearerToken#bearer_login?`
- Add `Shield::BearerLogins::Token::Show` action
- Add `Shield::EmailConfirmations::Token::Show` action
- Add `Shield::PasswordResets::Token::Show` action

### Changed
- Remove showing bearer token from `Shield::BearerLogins::Show` action
- Change `Shield::Api::EmailConfirmations::Show` to accept ID as path param
- Change `Shield::Api::PasswordResets::Show` to accept ID as path param
- Change `Shield::EmailConfirmations::Show` to show email confirmation by ID
- Change `Shield::PasswordResets::Show` to show password reset by ID

## [0.15.0] - 2022-06-28

### Added
- Add support for *Lucky* v0.30
- Add `Shield::Api::BearerLogins::Show` action
- Add `Shield::Api::BearerLogins::Update` action
- Add `Shield::BearerLogins::Edit` action
- Add `Shield::BearerLogins::Update` action
- Add `Shield::UpdateBearerLogin` operation

### Fixed
- Ensure a bearer login has no duplicate scopes
- Validate bearer login name format

## [0.14.0] - 2022-03-17

### Added
- Ensure support for *Crystal* v1.3
- Add `Shield::EndUserLogins` operation
- Add `Shield::DeleteUserLogins` operation
- Add `Shield::Api::CurrentUser::BearerLogins::*` actions
- Add `Shield::Api::CurrentUser::EmailConfirmations::*` actions
- Add `Shield::Api::CurrentUser::Logins::*` actions for user logins on all devices
- Add `Shield::Api::CurrentUser::PasswordResets::*` actions
- Add `Shield::Api::Users::BearerLogins::*` actions
- Add `Shield::Api::Users::EmailConfirmations::*` actions
- Add `Shield::Api::Users::Logins::*` actions for user logins on all devices
- Add `Shield::Api::Users::PasswordResets::*` actions
- Add `Shield::CurrentUser::BearerLogins::*` actions
- Add `Shield::CurrentUser::EmailConfirmations::*` actions
- Add `Shield::CurrentUser::Logins::*` actions for user logins on all devices
- Add `Shield::CurrentUser::PasswordResets::*` actions
- Add `Shield::Users::BearerLogins::*` actions
- Add `Shield::Users::EmailConfirmations::*` actions
- Add `Shield::Users::Logins::*` actions for user logins on all devices
- Add `Shield::Users::PasswordResets::*` actions
- Add `BearerToken#authenticate` methods
- Add `Shield::Api::EmailConfirmations::Delete` action
- Add `Shield::Api::EmailConfirmations::Destroy` action
- Add `Shield::Api::EmailConfirmations::Index` action
- Add `Shield::Api::EmailConfirmations::Show` action
- Add `Shield::Api::EmailConfirmations::Verify` action
- Add `Shield::Api::PasswordResets::Delete` action
- Add `Shield::Api::PasswordResets::Destroy` action
- Add `Shield::Api::PasswordResets::Index` action
- Add `Shield::Api::PasswordResets::Show` action
- Add `Shield::Api::PasswordResets::Verify` action
- Add `Shield::BearerLogins::Show` action
- Add `Shield::EmailConfirmations::Delete` action
- Add `Shield::EmailConfirmations::Destroy` action
- Add `Shield::EmailConfirmations::Index` action
- Add `Shield::PasswordResets::Delete` action
- Add `Shield::PasswordResets::Destroy` action
- Add `Shield::PasswordResets::Index` action
- Add `UpdatePassword` operation
- Add `success : Bool` column to password resets
- Add `success : Bool` column to email confirmations

### Changed
- Use saved status to determine status of create operations
- Respond with HTTP status code `400` in actions if operation failed
- Rename `Shield::LogOutEverywhere` operation mixin to `EndUserLoginsOnPasswordChange`
- Rename `Shield::DeleteLoginsOnPasswordChange` operation mixin to `DeleteUserLoginsOnPasswordChange`
- Repurpose `Shield::Api::Logins::Index` to return all active logins for all users
- Repurpose `Shield::Logins::Index` to return all active logins for all users
- Rename API action's `#current_bearer_user` to `#current_bearer`
- Rename API action's `#current_or_bearer_user` to `#current_user_or_bearer`
- Make `Shield::LoginHelpers` available in pages and components
- Rename `Shield::Api::EmailConfirmations::Edit` to `Shield::Api::EmailConfirmations::Update`
- Rename `Shield::EmailConfirmations::Edit` to `Shield::EmailConfirmations::Update`
- Rename `Shield::LogUserIn` operation mixin to `Shield::StartLogin`
- Rename `Shield::LogUserOut` operation mixin to `Shield::EndLogin`
- Convert `ResetPassword` from a `User::SaveOperation` to a `PasswordReset::SaveOperation`
- Convert `UpdateConfirmedEmail` from a `User::SaveOperation` to a `EmailConfirmation::SaveOperation`
- Replace `NamedTuple` responses in APIs entirely with serializers

### Fixed
- Prevent bearer users from deleting themselves
- Allow API logins with email and password without setting up bearer logins

### Removed
- Remove `Shield::VerificationUrl#route`
- Remove `BearerToken#to_header`
- Remove `Shield::BearerLogin::Create` action
- Remove `Shield::BearerLogin::New` action

## [0.13.1] - 2022-01-04

### Changed
- Redirect **back** if log out fails

### Fix
- Don't allow access to password in translations

## [0.13.0] - 2022-01-03

### Added
- Add support for *Lucky* v0.29
- Set up i18n with [*Rex*](https://github.com/GrottoPress/rex)

### Changed
- Remove `Lucky::Env` module in favour of [`LuckyEnv`](https://github.com/luckyframework/lucky_env)
- Restrict login verification error to password attribute only
- Convert `UserSettings` to a `struct`
- Extract bearer login validations into `Shield::ValidateBearerLogin`
- Extract email confirmation validations into `Shield::ValidateEmailConfirmation`
- Extract login validations into `Shield::ValidateLogin`
- Extract password reset validations into `Shield::ValidatePasswordReset`
- Extract user validations into `Shield::ValidateUser`
- Allow setting `bearer_login_expiry` to `nil` to disable expiry
- Allow setting `login_expiry` to `nil` to disable expiry
- Allow setting `login_idle_timeout` to `nil` to disable timeout

### Removed
- Drop support for *Lucky* v0.28
- Remove `Shield::NeverExpires` operation mixin

## [0.12.0] - 2021-11-22

### Added
- Add support for *Crystal* v1.2
- Allow including `Shield::ValidatePassword` in `Avram::Operation` operations

### Changed
- Use descending order for queries in index actions
- Integrate with [*Lucille*](https://github.com/GrottoPress/lucille)

### Removed
- Revert avoiding queries in validations if operation already invalid

## [0.11.0] - 2021-08-24

### Added
- Add support for *Lucky* v0.28
- Add `Shield::SetUserIdFromUser#user!` method
- Add `UserSettings` column to `User`, as an alternative to `UserOptions`.

### Changed
- Rename *bang* counterparts of nilable methods to their non-bang equivalents
- Append `?` to names of methods with nilable return values
- Prefer lazy loading for model associations

### Fixed
- Avoid making queries in validations if operation already invalid

### Removed
- Drop support for *Lucky* v0.27

## [0.10.0] - 2021-06-17

### Added
- Allow setting custom time for `Shield::Activate` and `Shield::Deactivate`
- Add `Shield::StatusQuery#is_active_at`

### Fixed
- Fix wrong pagination for active records in `Index` actions.

## [0.9.0] - 2021-04-15

### Added
- Add support for *Lucky* v0.27
- Add `Shield::Logins::Delete` action.
- Add `Shield::Logins::Destroy` action.
- Add `Shield::Logins::Index` action.
- Add `Shield::Api::Logins::Delete` action.
- Add `Shield::Api::Logins::Destroy` action.
- Add `Shield::Api::Logins::Index` action.
- Add `Shield::Logins::Delete` action.
- Add `Shield::Logins::Destroy` action.
- Add `Shield::Api::Logins::Delete` action.
- Add `Shield::Api::Logins::Destroy` action.

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
