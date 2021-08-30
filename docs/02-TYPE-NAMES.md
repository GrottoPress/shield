## Type Names

*Shield* uses the following type names:

### Data Models

- `BaseModel`
- `BearerLogin`
- `EmailConfirmation`
- `Login`
- `PasswordReset`
- `User`
- `UserOptions`
- `UserSettings`

### Queries

- `BearerLoginQuery`
- `EmailConfirmationQuery`
- `LoginQuery`
- `PasswordResetQuery`
- `UserOptionsQuery`
- `UserQuery`

### Emails

- `BearerLoginNotificationEmail`
- `EmailConfirmationRequestEmail`
- `GuestPasswordResetRequestEmail`
- `LoginNotificationEmail`
- `PasswordChangeNotificationEmail`
- `PasswordResetRequestEmail`
- `UserEmailConfirmationRequestEmail`
- `UserWelcomeEmail`
- `WelcomeEmail`

### Operations

- `CreateBearerLogin`
- `DeleteBearerLogin`
- `DeleteCurrentLogin`
- `DeleteEmailConfirmation`
- `DeletePasswordReset`
- `DeleteUser`
- `EndEmailConfirmation`
- `EndPasswordReset`
- `LogUserIn`
- `LogUserOut`
- `RegisterCurrentUser`
- `RegisterUser`
- `ResetPassword`
- `RevokeBearerLogin`
- `SaveUserOptions`
- `StartEmailConfirmation`
- `StartPasswordReset`
- `UpdateConfirmedEmail`
- `UpdateCurrentUser`
- `UpdateUser`

### Actions

- `ApiAction`
- `BearerLogins::Create`
- `BearerLogins::Destroy`
- `BearerLogins::Index`
- `BearerLogins::New`
- `BrowserAction`
- `CurrentLogin::Create`
- `CurrentLogin::Destroy`
- `CurrentLogin::New`
- `CurrentUser::Create`
- `CurrentUser::Edit`
- `CurrentUser::New`
- `CurrentUser::Show`
- `CurrentUser::Update`
- `EmailConfirmations::Create`
- `EmailConfirmations::Edit`
- `EmailConfirmations::New`
- `EmailConfirmations::Show`
- `Logins::Delete`
- `Logins::Destroy`
- `Logins::Index`
- `PasswordResets::Create`
- `PasswordResets::Edit`
- `PasswordResets::New`
- `PasswordResets::Show`
- `PasswordResets::Update`
- `Users::Create`
- `Users::Destroy`
- `Users::Edit`
- `Users::Index`
- `Users::New`
- `Users::Show`
- `Users::Update`

API equivalents, where applicable, are prefixed with `Api::`

### Pages

- `BearerLogins::IndexPage`
- `BearerLogins::NewPage`
- `BearerLogins::ShowPage`
- `CurrentLogin::NewPage`
- `CurrentUser::EditPage`
- `CurrentUser::NewPage`
- `CurrentUser::ShowPage`
- `EmailConfirmations::NewPage`
- `PasswordResets::EditPage`
- `PasswordResets::NewPage`
- `Users::EditPage`
- `Users::IndexPage`
- `Users::NewPage`
- `Users::ShowPage`

### Serializers

- `BearerLoginSerializer`
- `LoginSerializer`
- `UserSerializer`

### Domain Models

- `BcryptHash`
- `BearerLoginHeaders`
- `BearerScope`
- `BearerToken`
- `EmailConfirmationParams`
- `EmailConfirmationSession`
- `EmailConfirmationUrl`
- `LoginHeaders`
- `LoginIdleTimeoutSession`
- `LoginSession`
- `PageUrlSession`
- `PasswordAuthentication`
- `PasswordResetParams`
- `PasswordResetSession`
- `PasswordResetUrl`
- `ReturnUrlSession`
- `Sha256Hash`
