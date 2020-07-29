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

- `DeactivateLogin`
- `EndPasswordReset`
- `LogUserIn`
- `LogUserOut`
- `ResetPassword`
- `RegisterCurrentUser`
- `RegisterUser`
- `SaveUserOptions`
- `StartPasswordReset`
- `UpdateCurrentUser`
- `UpdateUser`
- `VerifyLogin`
- `VerifyPasswordReset`
- `VerifyUser`

### Actions

- `CurrentUser::Show`
- `Logins::New`
- `PasswordResets::Edit`
- `PasswordResets::Show`

If you would rather name your types differently, set aliases for your own types to these ones, thus:

```crystal
# ->>> config/types.cr

alias User = MyUserModel
alias UserQuery = MyUserQuery
# ...
```

Then `require` this alias file wherever the compiler yells about a missing type.
