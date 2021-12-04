## User

1. Set up the model:

   ```crystal
   # ->>> src/models/user.cr

   class User < BaseModel
     # ...
     include Shield::User

     table :users do
       # You may add more columns here
     end
     # ...
   end
   ```

   `Shield::User` adds the following columns:

   - `email : String`
   - `password_digest : String`

   You may add other columns and associations specific to your application.

1. Set up the migration:

   ```crystal
   # ->>> db/migrations/XXXXXXXXXXXXXX_create_users.cr

   class CreateUsers::VXXXXXXXXXXXXXX < Avram::Migrator::Migration::V1
     def migrate
       enable_extension "citext"

       create :users do
         # ...
         primary_key id : Int64

         add_timestamps

         add email : String, unique: true, case_sensitive: false
         add password_digest : String
         # ...
       end
     end

     def rollback
       drop :users
     end
   end
   ```

   Add any columns you added to the model here.

1. Set up operations:

   All operations are already set up. You may reopen an operation to add new functionality.

   ```crystal
   # ->>> src/operations/register_currrent_user.cr

   class RegisterCurrentUser < User::SaveOperation
     # Send welcome email
     #
     include Shield::SendWelcomeEmail
   end
   ```

   `RegisterCurrentUser` saves `email`, `password` and user options. If you added other columns and associations to the model, you may have to add callbacks for dealing with those.

   ---
   ```crystal
   # ->>> src/operations/update_currrent_user.cr

   class UpdateCurrentUser < User::SaveOperation
     # ...
     # By default, *Shield* marks all logins as inactive,
     # when password changes, without deleting them.
     #
     # Enable this to delete them from the database instead.
     #
     #include Shield::DeleteLoginsOnPasswordChange
     # ...
   end
   ```

   `UpdateCurrentUser` is similar to `RegisterCurrentUser`, except it *updates* an existing user rather than create a new one.

1. Set up actions:

   ```crystal
   # ->>> src/actions/current_user/new.cr

   class CurrentUser::New < BrowserAction
     # ...
     include Shield::CurrentUser::New

     get "/account/new" do
       operation = RegisterCurrentUser.new
       html NewPage, operation: operation
     end
     # ...
   end
   ```

   You may need to add `CurrentUser::NewPage` in `src/pages/current_user/new_page.cr`, containing your user registration form.

   The form should be `POST`ed to `CurrentUser::Create`, with the following parameters:

   - `email : String`
   - `password : String`

   You may skip this action if building an API.

   ---
   ```crystal
   # ->>> src/actions/current_user/create.cr

   class CurrentUser::Create < BrowserAction
     # ...
     include Shield::CurrentUser::Create

     post "/account" do
       run_operation
     end

     # What to do if `run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, user)
     #  success_action(operation)
     #end

     # What to do if `run_operation` fails
     #
     #def do_run_operation_failed(operation)
     #  # This assumes you are sending welcome emails.
     #  if operation.user_email?
     #    success_action(operation)
     #  else
     #    failure_action(operation)
     #  end
     #end

     # This assumes you are sending welcome emails.
     #private def success_action(operation)
     #  flash.success = Rex.t(:"action.current_user.create.success")
     #  redirect to: CurrentLogin::New
     #end

     #private def failure_action(operation)
     #  flash.failure = Rex.t(:"action.current_user.create.failure")
     #  html NewPage, operation: operation
     #end
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/actions/current_user/show.cr

   class CurrentUser::Show < BrowserAction
     # ...
     include Shield::CurrentUser::Show

     get "/account" do
       html ShowPage, user: user
     end
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/actions/current_user/edit.cr

   class CurrentUser::Edit < BrowserAction
     # ...
     include Shield::CurrentUser::Edit

     get "/account/edit" do
       operation = UpdateCurrentUser.new(user, current_login: current_login?)
       html EditPage, operation: operation
     end
     # ...
   end
   ```

   You may need to add `CurrentUser::EditPage` in `src/pages/current_user/edit_page.cr`, containing your user edit form.

   The form should be `PATCH`ed to `CurrentUser::Update`, with the following parameters:

   - `email : String`
   - `password : String`

   You may skip this action if building an API.

   ---
   ```crystal
   # ->>> src/actions/current_user/update.cr

   class CurrentUser::Update < BrowserAction
     # ...
     include Shield::CurrentUser::Update

     patch "/account" do
       run_operation
     end

     # What to do if `run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, user)
     #  flash.success = Rex.t(:"action.current_user.update.success")
     #  redirect to: Show
     #end

     # What to do if `run_operation` fails
     #
     #def do_run_operation_failed(operation)
     #  flash.failure = Rex.t(:"action.current_user.update.failure")
     #  html EditPage, operation: operation
     #end
     # ...
   end
   ```

1. Set up emails:

   ```crystal
   # ->>> src/emails/welcome_email.cr

   class WelcomeEmail < BaseEmail
     # ...
     def initialize(@operation : RegisterCurrentUser, @user : User)
     end

     # Sample message
     def text_body
       <<-MESSAGE
       Hi User ##{@user.id},

       You have successfully completed your registration for your <app name here> account.

       To access your account, log in via the following link:

       #{CurrentLogin::New.url}

       If you did not register this account, kindly reply to let us know.

       Regards,
       <app name here>.
       MESSAGE
     end
     # ...
   end
   ```

   This is the email sent to the email address of a newly registered user of your application. It is sent if you included `Shield::SendWelcomeEmail` in `RegisterCurrentUser`.

   ---
   ```crystal
   # ->>> src/emails/user_welcome_email.cr

   class UserWelcomeEmail < BaseEmail
     # ...
     def initialize(@operation : RegisterCurrentUser)
     end

     # Sample message
     def text_body
       <<-MESSAGE
       Hi,

       You (or someone else) entered this email address while trying to
       register for a new <app name here> account.

       The attempted action has failed, so there is nothing you should
       worry about.

       If you have lost your password, however, you may reset your password here:

       #{PasswordResets::New.url}

       Regards,
       <app name here>.
       MESSAGE
     end
     # ...
   end
   ```

   This is the email sent to the email address of an existing user, after someone tries to register a new account with said user's email.

   This email is sent if you included `Shield::SendWelcomeEmail` in `RegisterCurrentUser`.

### Other Types

1. Operations:

   - `DeleteUser`

   `DeleteUser` deletes a given user. It protects against self-deletion; a user cannot delete themselves.

1. Actions:

   - `Shield::Users::Create`
   - `Shield::Users::Delete`
   - `Shield::Users::Destroy`
   - `Shield::Users::Edit`
   - `Shield::Users::Index`
   - `Shield::Users::New`
   - `Shield::Users::Show`
   - `Shield::Users::Update`

   `Shield::Users::*` actions are reserved for situations where admins would like to perform certain operations on other registered users.
