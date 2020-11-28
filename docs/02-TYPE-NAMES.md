## Type Names

*Shield* assumes the following type names in your application:

### Models

- `BearerLogin`
- `EmailConfirmation`
- `Login`
- `PasswordReset`
- `User`
- `UserOptions`

### Queries

- `BearerLoginQuery`
- `EmailConfirmationQuery`
- `LoginQuery`
- `PasswordResetQuery`
- `UserQuery`
- `UserOptionsQuery`

### Emails

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
- `DeleteEmailConfirmation`
- `EndEmailConfirmation`
- `EndPasswordReset`
- `LogUserIn`
- `LogUserOut`
- `RegisterCurrentUser`
- `ResetPassword`
- `RevokeBearerLogin`
- `SaveUserOptions`
- `StartEmailConfirmation`
- `StartPasswordReset`
- `UpdateConfirmedEmail`
- `UpdateCurrentUser`

### Actions

- `BearerLogins::Create`
- `BearerLogins::Destroy`
- `BearerLogins::Index`
- `BearerLogins::New`
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
- `PasswordResets::Create`
- `PasswordResets::Edit`
- `PasswordResets::New`
- `PasswordResets::Show`
- `PasswordResets::Update`

### Pages

- `BearerLogins::IndexPage`
- `BearerLogins::NewPage`
- `BearerLogins::ShowPage`
- `CurrentLogin::NewPage`
- `CurrentUser::EditPage`
- `CurrentUser::NewPage`
- `EmailConfirmations::NewPage`
- `PasswordResets::EditPage`
- `PasswordResets::NewPage`

### Serializers

- `BearerLoginSerializer`
- `LoginSerializer`
- `UserSerializer`

### Utilities

- `BearerLoginHeaders`
- `EmailConfirmationParams`
- `EmailConfirmationSession`
- `LoginHeaders`
- `LoginSession`
- `PageUrlSession`
- `PasswordResetParams`
- `PasswordResetSession`
- `PwnedPasswords`
- `ReturnUrlSession`

### Helpers

- `BearerLoginHelper`
- `CryptoHelper`
- `EmailConfirmationHelper`
- `LoginHelper`
- `PasswordResetHelper`
- `UserHelper`

If you would rather name your types differently, set aliases for them, thus:

```crystal
# ->>> config/types.cr

alias User = MyUserModel
alias UserQuery = MyUserQuery
# ...
```

Then `require` this alias file wherever the compiler yells about a missing type.
