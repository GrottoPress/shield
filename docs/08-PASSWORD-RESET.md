## Password Reset

1. Set up the model

   ```crystal
   # ->>> src/models/password_reset.cr

   class PasswordReset < BaseModel
     # ...
     include Shield::PasswordReset

     table :password_resets do
       # You may add more columns here
     end
     # ...
   end
   ```

   `Shield::PasswordReset` adds the following columns:
   
   - `ended_at : Time?`
   - `ip_address : Socket::IPAddress`
   - `started_at : Time`
   - `status : PasswordReset::Status`
   - `token_hash : String`
   
   ...and sets up a one-to-many association with the `User` model.

   It removes *Lucky*'s default `created_at : Time` and `update_at : Time` columns.

   You may add other columns and associations specific to your application.

1. Set up the migration:

   ```crystal
   # ->>> db/migrations/XXXXXXXXXXXXXX_create_password_reset.cr

   class CreatePasswordReset::VXXXXXXXXXXXXXX < Avram::Migrator::Migration::V1
     def migrate
       create table_for(PasswordReset) do
         # ...
         primary_key id : Int64

         add_belongs_to user : User, on_delete: :cascade

         add token_hash : String
         add ip_address : String
         add status : String
         add started_at : Time
         add ended_at : Time?
         # ...
       end
     end

     def rollback
       drop table_for(PasswordReset)
     end
   end
   ```

   Add any columns you added to the model here.

1. Set up operations:

   ```crystal
   # ->>> src/operations/start_password_reset.cr

   class StartPasswordReset < PasswordReset::SaveOperation
     # ...
     include Shield::StartPasswordReset
     # ...
   end
   ```

   `Shield::StartPasswordReset` receives a `email` parameter, generates a token, sends email, and saves the relevant values in the database.

   ---
   ```crystal
   # ->>> src/operations/end_password_reset.cr

   class EndPasswordReset < PasswordReset::SaveOperation
     # ...
     include Shield::EndPasswordReset
     # ...
   end
   ```

   `Shield::EndPasswordReset` marks a password reset inactive, to ensure it is never reused.

   ---
   ```crystal
   # ->>> src/operations/reset_password.cr

   class ResetPassword < User::SaveOperation
     # ...
     include Shield::ResetPassword
     # ...
   end
   ```

   `Shield::ResetPassword` does the actual work of updating the user's password, after which it defers to `EndPasswordReset`.

1. Set up actions:

   ```crystal
   # ->>> src/actions/password_resets/new.cr

   class PasswordResets::New < BrowserAction
     # ...
     include Shield::NewPasswordReset

     get "/password-resets/new" do
       html NewPage
     end
     # ...
   end
   ```

   You may need to add `PasswordResets::NewPage` in `src/pages/password_resets/new_page.cr`, containing your password reset request form.

   The form should be `POST`ed to `PasswordResets::Create`, with the following parameters:

   - `email : String`

   You may skip this action if building an API.

   ---
   ```crystal
   # ->>> src/actions/password_resets/create.cr

   class PasswordResets::Create < BrowserAction
     # ...
     include Shield::CreatePasswordReset

     post "/password-resets" do
       start_password_reset
     end

     # What to do if `start_password_reset` succeeds
     #
     #private def success_action(operation, login)
     #  success_action
     #end

     # What to do if `start_password_reset` fails
     #
     #private def failure_action(operation)
     #  if operation.guest_email?
     #     success_action
     #   else
     #     flash.failure = "Password reset request failed"
     #     html NewPage, operation: operation
     #   end
     #end

     #private def success_action
     #  flash.success = "Done! Check your email for further instructions."
     #  redirect to: Logins::New
     #end
     # ...
   end
   ```

   `StartPasswordReset#guest_email?` is `true` if the email is a valid email address, but is not in our application's database.

   By default, the same action is performed for a guest email as we would do for a registered user's email address. This is to prevent [username enumeration](https://www.troyhunt.com/everything-you-ever-wanted-to-know/).

   ---
   ```crystal
   # ->>> src/actions/password_resets/show.cr

   class PasswordResets::Show < BrowserAction
     # ...
     include Shield::ShowPasswordReset

     param id : Int64
     param token : String

     get "/password-resets" do
       set_session
     end
     # ...
   end
   ```

   `Shield::ShowPasswordReset` is just a pass-through to avoid leaking password reset tokens to third parties, via the HTTP referer header.

   It sets the id and token, retrieved from params, in session, and redirects to the route responsible for actual verification.

   ---
   ```crystal
   # ->>> src/actions/password_resets/edit.cr

   class PasswordResets::Edit < BrowserAction
     # ...
     include Shield::EditPasswordReset

     get "/password-resets/edit" do
       verify_password_reset
     end

     # What to do if `verify_password_reset` succeeds
     #
     #private def success_action(password_reset)
     #  html EditPage
     #end

     # What to do if `verify_password_reset` fails
     #
     #private def failure_action
     #  flash.failure = "Invalid token"
     #  redirect to: New
     #end
     # ...
   end
   ```

   You may need to add `PasswordResets::EditPage` in `src/pages/password_resets/edit_page.cr`, containing your password edit form.

   The form should be `PATCHED`ed to `PasswordResets::Update`, with the following parameters:

   - `password : String`
   - `password_confirmation : String`

   You may skip this action if building an API.

   ---
   ```crystal
   # ->>> src/actions/password_resets/update.cr

   class PasswordResets::Update < BrowserAction
     # ...
     include Shield::UpdatePasswordReset

     patch "/password-resets" do
       reset_password
     end

     # What to do if `reset_password` succeeds
     #
     #private def success_action(operation, user)
     #  flash.success = "Password changed successfully"
     #  redirect to: Logins::New
     #end

     # What to do if `reset_password` fails
     #
     #private def failure_action(operation, user)
     #  flash.failure = "Could not change password"
     #  html EditPage, operation: operation, user: user
     #end
     # ...
   end
   ```
