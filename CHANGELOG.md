# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreelased] - 

### Changed
- Allow `PasswordAuthentication#initialize` to accept a nilable `User`

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

## [0.21.0] - 2023-05-02

### Changed
- Upgrade `GrottoPress/lucille` shard to v0.11

## [0.20.0] - 2023-03-13

### Added
- Add support for CockroachDB

### Changed
- Upgrade to support *Lucky* v1.0

## [0.19.0] - 2023-01-06

### Added
- Add `BearerTokenSession.new(context : HTTP::Server::Context)` overload
- Add `EmailConfirmationSession.new(context : HTTP::Server::Context)` overload
- Add `LoginIdleTimeoutSession.new(context : HTTP::Server::Context)` overload
- Add `LoginSession.new(context : HTTP::Server::Context)` overload
- Add `OauthClientHeaders.new(context : HTTP::Server::Context)` overload
- Add `OauthClientSession.new(context : HTTP::Server::Context)` overload
- Add `OauthStateSession.new(context : HTTP::Server::Context)` overload
- Add `PageUrlSession.new(context : HTTP::Server::Context)` overload
- Add `PasswordResetSession.new(context : HTTP::Server::Context)` overload
- Add `ReturnUrlSession.new(context : HTTP::Server::Context)` overload

### Changed
- Do not delete secrets by default, after fetching from session.
- Drop `create_user` parameter from `Shield::HttpClient` auth methods
- Delete email confirmation session after delete email confirmation
- Delete login session after delete login
- Delete password reset session after delete password reset
- I18n: Rename `action.pipe.oauth.auth_code_invalid` key to `action.pipe.oauth.code_invalid`
- I18n: Rename `operation.error.oauth_client_id_required` key to `operation.error.oauth.client_id_required`
- I18n: Rename `operation.error.oauth_client_inactive` key to `operation.error.oauth.client_inactive`
- I18n: Rename `operation.error.oauth_client_not_authorized` key to `operation.error.oauth.client_not_authorized`
- I18n: Rename `operation.error.oauth_client_not_found` key to `operation.error.oauth.client_not_found`
- I18n: Rename `operation.error.oauth_client_public` key to `operation.error.oauth.client_public`
- I18n: Rename `operation.error.oauth_code_required` key to `operation.error.oauth.code_required`
- I18n: Rename `operation.error.oauth_grant_inactive` key to `operation.error.oauth.grant_inactive`
- I18n: Rename `operation.error.oauth_grant_type_invalid` key to `operation.error.grant_type_invalid`

## [0.18.0] - 2022-11-21

### Added
- Add `BearerLoginHeaders.new(HTTP::Server::Context)` overload
- Add `LoginHeaders.new(HTTP::Server::Context)` overload

### Changed
- Upgrade to support *Crystal* v1.6
- Rename `CreateOauthAccessTokenFromClient#refresh_token` to `#credentials`
- Rename `CreateOauthAccessTokenFromGrant#refresh_token` to `#credentials`
- Rename `RotateOauthGrant#refresh_token` to `#credentials`

### Removed
- Remove `Shield::Hash#initialize`
- Remove `ApiAction` and `BrowserAction` from presets

## [0.17.0] - 2022-10-15

### Added
- Add support for OAuth refresh token revocation
- Add `Shield::Api::CurrentUser::OauthPermissions::Delete` action
- Add `Shield::Api::CurrentUser::OauthPermissions::Destroy` action
- Add `Shield::Api::Users::OauthPermissions::Delete` action
- Add `Shield::Api::Users::OauthPermissions::Destroy` action
- Add `Shield::Api::Logins::Token::Verify` action
- Add `Shield::CurrentUser::OauthPermissions::Delete` action
- Add `Shield::CurrentUser::OauthPermissions::Destroy` action
- Add `Shield::Users::OauthPermissions::Delete` action
- Add `Shield::Users::OauthPermissions::Destroy` action
- Add `iss` claim to OAuth token introspection response
- Require `scope` at OAuth token endpoint for Client Credentials grants
- Accept `scope` at OAuth token endpoint for Refresh Token grants
- Validate `scope` at OAuth token endpoint

### Fixed
- Fix authentication bypass in `#oauth_maybe_require_logged_in` pipe

### Changed
- Upgrade to support *Lucky* v1.0.0-rc1
- Change successful token revocation response to `{"active": false}`
- Rename `Shield::Api::BearerLogins::Verify` to `Shield::Api::BearerLogins::Token::Verify`
- Rename `Shield::Api::EmailConfirmations::Verify` to `Shield::Api::EmailConfirmations::Token::Verify`
- Rename `Shield::Api::PasswordResets::Verify` to `Shield::Api::PasswordResets::Token::Verify`
- Allow `OauthClient#redirect_uri` column to be updated
- Accept unnested params for `Api::Oauth::Authorization::Create`
- Do not `include Shield::Api::BearerLoginPipes` in `ApiAction` by default
- Allow setting multiple redirect URIs for OAuth clients

### Removed
- Remove `Shield::Api::OauthPermissions::Delete` action
- Remove `Shield::Api::OauthPermissions::Destroy` action
- Remove `Shield::OauthPermissions::Delete` action
- Remove `Shield::OauthPermissions::Destroy` action
- Remove `operation.error.token_not_access_token` translation key

## [0.16.0] - 2022-09-22

### Added
- Add OAuth 2.0 server
- Add `Shield::Api::BearerLogins::Verify` action
- Add `Shield::Api::Logins::Show` action
- Add `Shield::BearerLogins::Token::Show` action
- Add `Shield::EmailConfirmations::Token::Show` action
- Add `Shield::Logins::Show` action
- Add `Shield::PasswordResets::Token::Show` action
- Add `.bearer_login_scopes_allowed` setting
- Add `BearerLoginCredentials` utility
- Add `BearerLoginParams` utility
- Add `EmailConfirmationCredentials` utility
- Add `LoginCredentials` utility
- Add `PasswordResetCredentials` utility
- Add support for all database primary key types (not just `Int64`)
- Set `Pragma: no-cache` response header in `Shield::LoginPipes#disable_cache`
- Add `UpdateEmailConfirmationUser#credentials` getter

### Changed
- Remove showing bearer token from `Shield::BearerLogins::Show` action
- Change `Shield::Api::EmailConfirmations::Show` to accept ID as path param
- Change `Shield::Api::PasswordResets::Show` to accept ID as path param
- Change `Shield::EmailConfirmations::Show` to show email confirmation by ID
- Change `Shield::PasswordResets::Show` to show password reset by ID
- Restrict bearer login names to alphanumeric words, hyphens, underscores and parentheses.
- Send `WWW-Authenticate` response header for invalid login tokens in APIs
- Omit `error` from `WWW-Authenticate` response header if request lacks token
- Rename `Shield::LoginIdleTimeoutSession#expired?` to `#login_expired?`
- Increase cryptographic token sizes from 24 to 32 bytes
- Treat a valid bearer login with invalid scopes as logged out

### Fixed
- Ensure admins cannot view bearer tokens of others

### Removed
- Remove `EmailConfirmationUrl` utility
- Remove `PasswordResetUrl` utility
- Remove `Shield::VerificationUrl` utility mixin
- Remove `BearerToken` utility
- Remove `Shield::Session` utility mixin
- Remove `UpdateEmailConfirmationUser#email_confirmation` getter
- Remove `UpdateEmailConfirmationUser#start_email_confirmation` getter

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
