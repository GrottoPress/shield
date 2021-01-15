## Password Reset

1. Configure:

   ```crystal
   # ->>> config/shield.cr

   Shield.configure do |settings|
     # ...
     # How long should a password reset last before it expires?
     #settings.password_reset_expiry = 30.minutes
     # ...
   end
   ```

1. Set up models:

   ---
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
   - `token_digest : String`

   It removes *Lucky*'s default `created_at : Time` and `update_at : Time` columns.

   You may add other columns and associations specific to your application.

1. Set up the migration:

   ```crystal
   # ->>> db/migrations/XXXXXXXXXXXXXX_create_password_resets.cr

   class CreatePasswordResets::VXXXXXXXXXXXXXX < Avram::Migrator::Migration::V1
     def migrate
       create table_for(PasswordReset) do
         # ...
         primary_key id : Int64

         add_belongs_to user : User, on_delete: :cascade

         add token_digest : String
         add ip_address : String
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

   All operations are already set up. You may reopen an operation to add new functionality.

   ```crystal
   # ->>> src/operations/start_password_reset.cr

   class StartPasswordReset < PasswordReset::SaveOperation
     # ...
     # By default, *Shield* sets the `ended_at` time here, using
     # the expiry setting above.
     #
     # Use this, if you would like to never expire password resets,
     # irrespective of the expiry setting.
     #include Shield::NeverExpires
     # ...
   end
   ```

   `StartPasswordReset` receives a `email` parameter, generates a token, sends email, and saves the relevant values in the database.

   ---
   ```crystal
   # ->>> src/operations/end_password_reset.cr

   class EndPasswordReset < PasswordReset::SaveOperation
     # ...
   end
   ```

   `EndPasswordReset` marks a password reset inactive, to ensure it is never reused.

   ---
   ```crystal
   # ->>> src/operations/delete_password_reset.cr

   class DeletePasswordReset < Avram::Operation
     # ...
   end
   ```

   `DeletePasswordReset` actually deletes a given password reset from the database. Use this instead of `EndPasswordReset` if you intend to actually delete password resets, rather than mark them as inactive.

   ---
   ```crystal
   # ->>> src/operations/reset_password.cr

   class ResetPassword < User::SaveOperation
     # ...
     # By default, *Shield* marks all password resets as inactive,
     # after a successful reset, without deleting them.
     #
     # Enable this to delete them from the database instead.
     #
     #include Shield::DeletePasswordResetsAfterResetPassword
     # ...
   end
   ```

   `ResetPassword` does the actual work of updating a user's password, after which it deactivates all active password resets for that user.

1. Set up actions:

   ```crystal
   # ->>> src/actions/browser_action.cr

   abstract class BrowserAction < Lucky::Action
     # ...
     # What to do when a user's IP address changes in a password reset, if the
     # action requires the user's IP to match the IP with which they requested
     # the password reset.
     #
     #def do_pin_password_reset_to_ip_address_failed
     #  flash.keep.failure = "Your IP address has changed. Please try again."
     #  redirect to: PasswordResets::New
     #end
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/actions/password_resets/new.cr

   class PasswordResets::New < BrowserAction
     # ...
     include Shield::PasswordResets::New

     get "/password-resets/new" do
       operation = StartPasswordReset.new(remote_ip: remote_ip)
       html NewPage, operation: operation
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
     #  if Lucky::Env.production?
     #    success_action(operation)
     #  else
     #    flash.keep.success = "Development mode: No need to check your mail."
     #    redirect to: PasswordResetUrl.new(operation, password_reset)
     #  end
     #end

     # What to do if `run_operation` fails
     #
     #def do_run_operation_failed(operation)
     #  if operation.guest_email?
     #     success_action(operation)
     #   else
     #     failure_action(operation)
     #   end
     #end

     #private def success_action(operation)
     #  flash.keep.success = "Done! Check your email for further instructions."
     #  redirect to: CurrentLogin::New
     #end

     #private def failure_action(operation)
     #  flash.failure = "Password reset request failed"
     #  html NewPage, operation: operation
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

     param token : String

     get "/password-resets" do
       run_operation
     end
     # ...
   end
   ```

   `Shield::PasswordResets::Show` is just a pass-through to avoid leaking password reset tokens to third parties, via the HTTP referer header.

   It sets the token, retrieved from params, in session, and redirects to the route responsible for actual verification.

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

     # What to do if token verification fails
     #
     #def do_verify_operation_failed(utility)
     #  flash.keep.failure = "Invalid token"
     #  redirect to: New
     #end
     # ...
   end
   ```

   You may need to add `PasswordResets::EditPage` in `src/pages/password_resets/edit_page.cr`, containing your password edit form.

   The form should be `PATCH`ed to `PasswordResets::Update`, with the following parameters:

   - `password : String`

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

     # What to do if token verification fails
     #
     #def do_verify_operation_failed(utility)
     #  flash.keep.failure = "Invalid token"
     #  redirect to: New
     #end

     # What to do if `run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, user)
     #  flash.keep.success = "Password changed successfully"
     #  redirect to: CurrentLogin::New
     #end

     # What to do if `run_operation` fails
     #
     #def do_run_operation_failed(operation)
     #  flash.failure = "Could not change password"
     #  html EditPage, operation: operation
     #end
     # ...
   end
   ```

1. Set up emails:

   ```crystal
   # ->>> src/emails/password_reset_request_email.cr

   class PasswordResetRequestEmail < BaseEmail
     # ...
     def initialize(@operation : StartPasswordReset, @password_reset : PasswordReset)
     end

     # Sample message
     def text_body
       <<-MESSAGE
       Hi User ##{@password_reset.user!.id},

       You (or someone else) recently requested to reset the password
       for your <app name here> account.

       To proceed with the password reset process, click the link below:

       #{PasswordResetUrl.new(@operation, @password_reset)}

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

   This is a password reset email sent to the email address of a registered user of your application. It should contain the password reset URL.

   ---
   ```crystal
   # ->>> src/emails/guest_password_reset_request_email.cr

   class GuestPasswordResetRequestEmail < BaseEmail
     # ...
     def initialize(@operation : StartPasswordReset)
     end

     # Sample message
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

   This email is sent to a valid email address that requested a password reset, but the email did not belong to any registered user of your application.
