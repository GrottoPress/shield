## User Options

1. Set up models:

   ```crystal
   # ->>> src/models/user_options.cr

   class UserOptions < BaseModel
     # ...
     include Shield::UserOptions

     table :user_options do
       # You may add more columns here
     end
     # ...
   end
   ```

   `Shield::UserOptions` adds the following columns:

   - `password_notify : Bool`

   You may add other columns and associations specific to your application.

1. Set up the migration:

   ```crystal
   # ->>> db/migrations/XXXXXXXXXXXXXX_create_user_options.cr

   class CreateUserOptions::VXXXXXXXXXXXXXX < Avram::Migrator::Migration::V1
     def migrate
       create table_for(UserOptions) do
         # ...
         primary_key id : Int64

         add_timestamps
         add_belongs_to user : User, on_delete: :cascade, unique: true

         add password_notify : Bool
         # ...
       end
     end

     def rollback
       drop table_for(UserOptions)
     end
   end
   ```

   Add any columns you added to the model here.

1. Set up operations:

   All operations are already set up. You may reopen an operation to add new functionality.

   ```crystal
   # ->>> src/operations/save_user_options.cr

   class SaveUserOptions < UserOptions::SaveOperation
     # ...
   end
   ```

   `SaveUserOptions` saves `login_notify` and `password_notify`. If you added other columns and associations to the model, you may have to add callbacks for dealing with those.

1. Set up actions:

   User options do not have its own actions, since it is an extension of the `User` model in its own table.

   Operations and actions related to the `User` model already take care of saving user options.

   User edit forms, are therefore, required to include user options parameters, nested under its own key (`user_options`):

   - `login_notify : Bool`
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
