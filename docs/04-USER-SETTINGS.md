## User Settings

*Shield* comes with `UserSettings`, a `JSON::Serializable` column on the `User` model, as an alternative to `UserOptions` model.

You may use either `UserSettings` or `UserOptions`, but not both, in a single application.

1. Set up models:

   ```crystal
   # ->>> src/models/user_settings.cr

   struct UserSettings
     # ...
     include Shield::UserSettings
     # ...
   end
   ```

   `Shield::UserSettings` adds the following properties:

   - `password_notify : Bool`

   You may add other properties specific to your application.

   ---
   ```crystal
   # ->>> src/models/user.cr

   class User < BaseModel
     # ...
     include Shield::UserSettingsColumn
     # ...
   end
   ```

1. Set up the migration:

   ```crystal
   # ->>> db/migrations/XXXXXXXXXXXXXX_add_settings_to_users.cr

   class AddSettingsToUsers::VXXXXXXXXXXXXXX < Avram::Migrator::Migration::V1
     def migrate
       alter :users do
         # ...
         add settings : JSON::Any, default: JSON.parse({
           password_notify: true,
         }.to_json)
         # ...
       end
     end

     def rollback
       alter :users do
         remove :settings
       end
     end
   end
   ```

1. Set up actions:

   User settings does not have its own actions. Operations and actions related to the `User` model already take care of saving user settings.

   User edit forms, are therefore, required to include user settings parameters, nested under the `user` key:

   - `password_notify : Bool`

1. Set up emails:

   ```crystal
   # ->>> src/emails/password_change_notification_email.cr

   class PasswordChangeNotificationEmail < BaseEmail
     # ...
     def initialize(@operation : User::SaveOperation, @user : User)
     end

     # Sample message
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

   Each registered user has the option to receive this notification email when they (or someone else) updates or resets their password.
