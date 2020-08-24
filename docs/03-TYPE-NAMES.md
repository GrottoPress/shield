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

- `GuestPasswordResetRequestEmail`
- `LoginNotificationEmail`
- `PasswordChangeNotificationEmail`
- `PasswordResetRequestEmail`

### Operations

- `EndPasswordReset`
- `LogUserIn`
- `LogUserOut`
- `RegisterCurrentUser`
- `RegisterUser`
- `ResetPassword`
- `SaveUserOptions`
- `StartPasswordReset`
- `UpdateCurrentUser`
- `UpdateUser`

### Actions

- `CurrentUser::Show`
- `Logins::New`
- `PasswordResets::Edit`
- `PasswordResets::New`
- `PasswordResets::Show`

### Pages

- `CurrentUser::EditPage`
- `CurrentUser::NewPage`
- `Logins::NewPage`
- `PasswordResets::EditPage`
- `PasswordResets::NewPage`

### Utilities

- `LoginSession`
- `PageUrlSession`
- `PasswordResetSession`

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
