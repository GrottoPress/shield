## Type Names

*Shield* assumes the following type names in your application:

### Models

- `Login`
- `PasswordReset`
- `User`
- `UserOptions`

### Queries

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

- `EndPasswordReset`
- `LogUserIn`
- `LogUserOut`
- `RegisterCurrentUser`
- `ResetPassword`
- `SaveUserOptions`
- `StartEmailConfirmation`
- `StartPasswordReset`
- `UpdateConfirmedEmail`
- `UpdateCurrentUser`

### Actions

- `CurrentUser::Create`
- `CurrentUser::Edit`
- `CurrentUser::New`
- `CurrentUser::Show`
- `CurrentUser::Update`
- `EmailConfirmations::Create`
- `EmailConfirmations::New`
- `EmailConfirmations::Show`
- `EmailConfirmations::Update`
- `Logins::Create`
- `Logins::Destroy`
- `Logins::New`
- `PasswordResets::Create`
- `PasswordResets::Edit`
- `PasswordResets::New`
- `PasswordResets::Show`
- `PasswordResets::Update`

### Pages

- `CurrentUser::EditPage`
- `CurrentUser::NewPage`
- `EmailConfirmations::NewPage`
- `Logins::NewPage`
- `PasswordResets::EditPage`
- `PasswordResets::NewPage`

### Utilities

- `EmailConfirmation`
- `EmailConfirmationSession`
- `LoginSession`
- `PageUrlSession`
- `PasswordResetSession`
- `ReturnUrlSession`

### Helpers

- `CryptoHelper`
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
