## Emails

1. `LoginNotificationEmail`

   Each registered user has the option to receive this notification email when they (or someone else) logs in into their account.

   ```crystal
   # ->>> src/emails/login_notification_email.cr

   class LoginNotificationEmail < BaseEmail
     # ...
     def initialize(@operation : LogUserIn, @login : Login)
     end
     # ...
   end
   ```

   *Sample Message*:

   ```crystal
   # ->>> src/emails/login_notification_email.cr
   
   class LoginNotificationEmail < BaseEmail
     # ...
     def text_body
       <<-MESSAGE
       Hi User ##{@login.user!.id},

       This is to let you know that your <app name here> account has just been
       accessed.

       If you did not log in yourself, let us know immediately in your reply
       to this message. Otherwise, you may safely ignore this email.

       Regards,
       <app name here>.
       MESSAGE
     end
     # ...
   end
   ```

1. `PasswordChangeNotificationEmail`

   Each registered user has the option to receive this notification email when they (or someone else) updates or resets their password.

   ```crystal
   # ->>> src/emails/password_change_notification_email.cr

   class PasswordChangeNotificationEmail < BaseEmail
     # ...
     def initialize(@operation : User::SaveOperation, @user : User)
     end
     # ...
   end
   ```

   *Sample Message*:

   ```crystal
   # ->>> src/emails/src/emails/password_change_notification_email.cr
   
   class PasswordChangeNotificationEmail < BaseEmail
     # ...
     def text_body
       <<-MESSAGE
       Hi User ##{@user.id},

       This is to let you know that the password for your <app name here> account
       has just been changed.

       If you did not authorize this change, let us know immediately in your
       reply to this message. Otherwise, you may safely ignore this email.

       Regards,
       <app name here>.
       MESSAGE
     end
     # ...
   end
   ```

1. `PasswordResetRequestEmail`:

   This is a password reset email sent to the email address of a registered user of your application. It should contain the password reset URL.

   ```crystal
   # ->>> src/emails/password_reset_request_email.cr
   
   class PasswordResetRequestEmail < BaseEmail
     # ...
     def initialize(@operation : StartPasswordReset, @password_reset : PasswordReset)
     end
     # ...
   end
   ```

   *Sample Message*:

   ```crystal
   # ->>> src/emails/password_reset_request_email.cr
   
   class PasswordResetRequestEmail < BaseEmail
     # ...
     def text_body
       <<-MESSAGE
       Hi User ##{@password_reset.user!.id},

       You (or someone else) recently requested to reset the password
       for your <app name here> account.

       To proceed with the password reset process, click the link below:

       #{PasswordResetHelper.password_reset_url(@password_reset, @operation)}

       This password reset link will expire in #{Shield.settings.password_reset_expiry.total_minutes.to_i} minutes.

       If you did not request a password reset, ignore this email or
       reply to let us know.

       Regards,
       <app name here>.
       MESSAGE
     end
     # ...
   end
   ```

1. `GuestPasswordResetRequestEmail`:

   This email is sent to a valid email address that requested a password reset, but the email did not belong to any registered user of your application.

   ```crystal
   # ->>> src/emails/guest_password_reset_request_email.cr
   
   class GuestPasswordResetRequestEmail < BaseEmail
     # ...
     def initialize(@operation : StartPasswordReset)
     end
     # ...
   end
   ```

   *Sample Message*:

   ```crystal
   # ->>> src/emails/guest_password_reset_request_email.cr
   
   class GuestPasswordResetRequestEmail < BaseEmail
     # ...
     def text_body
       <<-MESSAGE
       Hi,

       You (or someone else) entered this email address while trying to
       change the password of a <app name here> account.

       However, this email address is not in our database. Therefore,
       the attempted password change has failed.

       If you are a <app name here> user and were expecting this email,
       you may try again using the email address you gave when you
       registered your account.

       If you are not a <app name here> user, ignore this email.

       Regards,
       <app name here>.
       MESSAGE
     end
     # ...
   end
   ```
