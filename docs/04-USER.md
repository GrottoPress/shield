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
   
   ...and sets up the relevant associations with other *Shield* models.

   You may add other columns and associations specific to your application.

1. Set up the query:

   ```crystal
   # ->>> src/queries/user_query.cr

   class UserQuery < User::BaseQuery
     # ...
     include Shield::UserQuery
     # ...
   end
   ```

1. Set up the migration:

   ```crystal
   # ->>> db/migrations/XXXXXXXXXXXXXX_create_users.cr

   class CreateUsers::VXXXXXXXXXXXXXX < Avram::Migrator::Migration::V1
     def migrate
       create table_for(User) do
         # ...
         primary_key id : Int64

         add_timestamps

         add email : String, unique: true
         add password_digest : String
         # ...
       end
     end

     def rollback
       drop table_for(User)
     end
   end
   ```

   Add any columns you added to the model here.

1. Set up operations:

   ```crystal
   # ->>> src/operations/register_currrent_user.cr

   class RegisterCurrentUser < User::SaveOperation
     # ...
     include Shield::RegisterUser
     include Shield::SendWelcomeEmail
     # ...
   end
   ```

   `Shield::RegisterUser` saves `email`, `password` and user options. If you added other columns and associations to the model, you may have to add callbacks for dealing with those.

   ---
   ```crystal
   # ->>> src/operations/update_currrent_user.cr

   class UpdateCurrentUser < User::SaveOperation
     # ...
     include Shield::UpdateUser

     # By default, *Shield* marks all logins as inactive,
     # when password changes, without deleting them.
     #
     # Enable this to delete them from the database instead.
     #
     #include Shield::DeleteLoginsOnPasswordChange
     # ...
   end
   ```

   `Shield::UpdateUser` is similar to `Shield::RegisterUser`, except it *updates* an existing user rather than create a new one.

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
     #  flash.keep.success = "Done! Check your email for further instructions."
     #  redirect to: CurrentLogin::New
     #end

     #private def failure_action(operation)
     #  flash.failure = "Could not create your account"
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
       operation = UpdateCurrentUser.new(user)
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
     #  flash.keep.success = "Account updated successfully"
     #  redirect to: Show
     #end

     # What to do if `run_operation` fails
     #
     #def do_run_operation_failed(operation)
     #  flash.failure = "Could not update your account"
     #  html EditPage, operation: operation
     #end
     # ...
   end
   ```

1. Set up helpers:

   ```crystal
   # ->>> src/helpers/user_helper.cr

   module UserHelper
     # ...
     extend Shield::UserHelper
     # ...
   end
   ```

   `Shield::UserHelper` contains helper methods related to the user model.

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