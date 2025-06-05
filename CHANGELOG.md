# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unrelased] - 

### Added
- Add support for Lucky v1.4

### Changed
- Allow `PasswordAuthentication#initialize` to accept a nilable `User`

### Fixed
- Allow nil in attribute size validations
- Fix compile error calling `.compare_versions` with `Shield::VERSION`

## [1.4.1] - 2025-01-04

### Fixed
- Delete *all* session on log out (not just the login ID and token)

## [1.4.0] - 2024-10-23

### Fixed
- Add support for Lucky v1.3
- Add support for Crystal v1.13
- Add support for Crystal v1.14

## [1.3.1] - 2024-09-11

### Removed
- Remove model association presets

## [1.3.0] - 2024-09-11

### Changed
- Merge mixin presets into their respective main modules

## [1.2.2] - 2024-08-09

### Fixed
- Fix incorrect duplicate params check in OAuth pipes

## [1.2.1] - 2024-07-25

### Fixed
- Limit lengths of OAuth client and bearer login names to mitigate potential DoS

### Changed
- Change no-op methods in `Shield::Hash` to `abstract def`s

## [1.2.0] - 2024-07-05

### Fixed
- Fix CI issues with Lucky v1.2

### Changed
- Upgrade GitHub actions
- Move all `after_commit` database operations to `after_save`

## [1.1.2] - 2024-02-10

### Changed
- Simplify `EndOauthGrantGracefully` operation

## [1.1.1] - 2023-12-19

### Changed
- Send `403` status code if email confirmation token verification failed
- Send `403` status code if password reset token verification failed

## [1.1.0] - 2023-12-18

### Added
- Add support for Lucky v1.1
- Add `OauthGrantType.authorization_code` constructor
- Add `OauthGrantType.client_credentials` constructor
- Add `OauthGrantType.refresh_token` constructor
- Add `UserQuery#email` method
- Add `BearerLoginQuery#name(String)` method
- Add `OauthClientQuery#name(String)` method

### Fixed
- Query all email addresses case-insensitively

## [1.0.2] - 2023-09-22

### Changed
- I18n: Rename `operation.error.oauth_access_token_notify_required` key to `operation.error.oauth.access_token_notify_required`

## [1.0.1] - 2023-06-02

### Fixed
- Fix compile error with `Shield::ValidatePassword` mixin in basic operations

## [1.0.0] - 2023-06-01

### Added
- Add `EmailConfirmationCredentials.url` class method
- Add `PasswordResetCredentials.url` class method
- Add `PageUrlSession.safe_method?` class method

### Changed
- Upgrade `GrottoPress/lucille` shard to v1.0
- Do not skip default validations in operations outside *Shield*

### Removed
- Remove `include MailHelpers` from actions and operations
- Remove all deprecated code
