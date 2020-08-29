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
   - `ip_address : String`
   - `started_at : Time`
   - `status : PasswordReset::Status`
   - `token_digest : String`
   
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

         add token_digest : String
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

   `Shield::ResetPassword` does the actual work of updating a user's password, after which it deactivates all active password resets for that user.

1. Set up actions:

   ```crystal
   # ->>> src/actions/password_resets/new.cr

   class PasswordResets::New < BrowserAction
     # ...
     include Shield::PasswordResets::New

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
     include Shield::PasswordResets::Create

     post "/password-resets" do
       run_operation
     end

     # What to do if `run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, password_reset)
     #  success_action
     #end

     # What to do if `run_operation` fails
     #
     #def do_run_operation_failed(operation)
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
     include Shield::PasswordResets::Show

     param id : Int64
     param token : String

     get "/password-resets" do
       run_operation
     end
     # ...
   end
   ```

   `Shield::PasswordResets::Show` is just a pass-through to avoid leaking password reset tokens to third parties, via the HTTP referer header.

   It sets the id and token, retrieved from params, in session, and redirects to the route responsible for actual verification.

   ---
   ```crystal
   # ->>> src/actions/password_resets/edit.cr

   class PasswordResets::Edit < BrowserAction
     # ...
     include Shield::PasswordResets::Edit

     # If you are worried about users on mobile, you may want
     # to disable pinning a password reset to its IP address
     #skip :pin_password_reset_to_ip_address

     get "/password-resets/edit" do
       run_operation
     end

     # What to do if `run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, password_reset)
     #  html EditPage
     #end

     # What to do if `run_operation` fails
     #
     #def do_run_operation_failed(operation)
     #  flash.failure = "Invalid token"
     #  redirect to: New
     #end
     # ...
   end
   ```

   You may need to add `PasswordResets::EditPage` in `src/pages/password_resets/edit_page.cr`, containing your password edit form.

   The form should be `PATCH`ed to `PasswordResets::Update`, with the following parameters:

   - `password : String`
   - `password_confirmation : String`

   You may skip this action if building an API.

   ---
   ```crystal
   # ->>> src/actions/password_resets/update.cr

   class PasswordResets::Update < BrowserAction
     # ...
     include Shield::PasswordResets::Update

     # If you are worried about users on mobile, you may want
     # to disable pinning a password reset to its IP address
     #skip :pin_password_reset_to_ip_address

     patch "/password-resets" do
       run_operation
     end

     # What to do if `run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, user)
     #  flash.success = "Password changed successfully"
     #  redirect to: Logins::New
     #end

     # What to do if `run_operation` fails
     #
     #def do_run_operation_failed(operation, user)
     #  flash.failure = "Could not change password"
     #  html EditPage, operation: operation, user: user
     #end
     # ...
   end
   ```
