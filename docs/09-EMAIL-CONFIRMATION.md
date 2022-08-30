## Email Confirmation

*Shield* offers email confirmations, for the purpose of verifying a new email address supplied by a user, either when registering for a new account, or while updating their exisiting account.

Email confirmation provides very little, if any, security benefits. It, however, improves usability by ensuring that an email address is valid, exists and is owned by the user supplying it.

This is particularly important, since email addresses are usually the only means to reset passwords. If a user supplied the wrong email address, and lost their password, they are out of luck.

[Read this](https://www.forbes.com/sites/ianmorris/2017/08/01/when-companies-dont-verify-email-addresses-this-is-what-happens/) for more reasons why email confirmation may be important.

### Setting up

1. Configure:

   ```crystal
   # ->>> config/shield.cr

   Shield.configure do |settings|
     # ...
     # How long should email confirmation last before it expires?
     #settings.email_confirmation_expiry = 1.hour
     # ...
   end
   ```

1. Set up models:

   ```crystal
   # ->>> src/models/email_confirmation.cr

   class EmailConfirmation < BaseModel
     # ...
     include Shield::EmailConfirmation

     skip_default_columns # Optional

     table :email_confirmations do
       # You may add more columns here
     end
     # ...
   end
   ```

   `Shield::EmailConfirmation` adds the following columns:

   - `active_at : Time`
   - `email : String`
   - `inactive_at : Time?`
   - `ip_address : String`
   - `success : Bool`
   - `token_digest : String`

   You may add other columns and associations specific to your application.

   ---
   ```crystal
   # ->>> src/models/user.cr

   class User < BaseModel
     # ...
     include Shield::HasManyEmailConfirmations
     # ...
   end
   ```

1. Set up the migration:

   ```crystal
   # ->>> db/migrations/XXXXXXXXXXXXXX_create_email_confirmations.cr

   class CreateEmailConfirmations::VXXXXXXXXXXXXXX < Avram::Migrator::Migration::V1
     def migrate
       enable_extension "citext"

       create :email_confirmations do
         # ...
         primary_key id : Int64

         add_timestamps
         add_belongs_to user : User?, on_delete: :cascade

         add email : String, case_sensitive: false

         add token_digest : String
         add ip_address : String
         add active_at : Time
         add inactive_at : Time?
         add success : Bool
         # ...
       end
     end

     def rollback
       drop :email_confirmations
     end
   end
   ```

   Add any columns you added to the model here.

1. Set up operations:

   All operations are already set up. You may reopen an operation to add new functionality.

   ```crystal
   # ->>> src/operations/start_email_confirmation.cr

   class StartEmailConfirmation < EmailConfirmation::SaveOperation
     # ...
   end
   ```

   `StartEmailConfirmation` kicks off the entire process of confirming a given email address. It receives `email : String` and an optional `user_id` (for an existing user), and generates a link that it sends to the email address supplied.

   ---
   ```crystal
   # ->>> src/operations/end_email_confirmation.cr

   class EndEmailConfirmation < EmailConfirmation::SaveOperation
     # ...
   end
   ```

   `EndEmailConfirmation` marks an email confirmation inactive, to ensure it is never reused.

   ---
   ```crystal
   # ->>> src/operations/delete_email_confirmation.cr

   class DeleteEmailConfirmation < EmailConfirmation::DeleteOperation
     # ...
   end
   ```

   `DeleteEmailConfirmation` actually deletes a given *email confirmation* from the database. Use this instead of `EndEmailConfirmation` if you intend to actually delete email confirmations, rather than mark them as inactive.

   ---
   ```crystal
   # ->>> src/operations/register_currrent_user.cr

   class RegisterCurrentUser < User::SaveOperation
     # ...
     # Send welcome email
     #
     include Shield::SendWelcomeEmail

     # By default, *Shield* marks all email confirmations as inactive,
     # after successful registration, without deleting them.
     #
     # Enable this to delete them from the database instead.
     #
     #include Shield::DeleteEmailConfirmationsAfterRegisterUser
     # ...
   end
   ```

   `RegisterCurrentUser` creates a new user after they have verified their email address.

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
     #include Shield::DeleteUserLoginsOnPasswordChange
     # ...
   end
   ```

   `UpdateCurrentUser` updates an existing user, but does not save the new email. It starts a new email confirmation for the user if their email changed.

   ---
   ```crystal
   # ->>> src/operations/update_confirmed_email.cr

   class UpdateConfirmedEmail < EmailConfirmation::SaveOperation
     # ...
     # By default, *Shield* marks all email confirmations as inactive,
     # after successful update, without deleting them.
     #
     # Enable this to delete them from the database instead.
     #
     #include Shield::DeleteEmailConfirmationsAfterUpdateEmail
     # ...
   end
   ```

   `UpdateConfirmedEmail` updates an existing users email, after they have verified their address.

1. Set up actions:

   ```crystal
   # ->>> src/actions/browser_action.cr

   abstract class BrowserAction < Lucky::Action
     # ...
     # What to do when a user's IP address changes in an email confirmation, if the
     # action requires the user's IP to match the IP with which they started
     # the email confirmation.
     #
     #def do_pin_email_confirmation_to_ip_address_failed
     #  flash.failure = Rex.t(:"action.pipe.ip_address_changed")
     #  redirect to: ::EmailConfirmations::New
     #end
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/actions/email_confirmations/new.cr

   class EmailConfirmations::New < BrowserAction
     # ...
     include Shield::EmailConfirmations::New

     get "/email-confirmations/new" do
       operation = StartEmailConfirmation.new(remote_ip: remote_ip?)
       html NewPage, operation: operation
     end
     # ...
   end
   ```

   This action is where email confirmation for new users begin. Your "Signup/Register" link should point to this action.

   You may need to add `EmailConfirmations::NewPage` in `src/pages/email_confirmations/new_page.cr`, containing the email confirmation request form.

   The form should be `POST`ed to `EmailConfirmations::Create`, with the following parameters:

   - `email : String`

   You may skip this action if building an API.

   ---
   ```crystal
   # ->>> src/actions/email_confirmations/create.cr

   class EmailConfirmations::Create < BrowserAction
     # ...
     include Shield::EmailConfirmations::Create

     post "/email-confirmations" do
       run_operation
     end

     # What to do if `run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, email_confirmation)
     #  if LuckyEnv.production?
     #    success_action(operation)
     #  else
     #    flash.success = Rex.t(:"action.misc.dev_mode_skip_email")
     #    redirect to: EmailConfirmationCredentials.new(operation, email_confirmation).url
     #  end
     #end

     # What to do if `run_operation` fails
     #
     #def do_run_operation_failed(operation)
     #  if operation.user_email?
     #     success_action(operation)
     #   else
     #     failure_action(operation)
     #   end
     #end

     #private def success_action(operation)
     #  flash.success = Rex.t(:"action.email_confirmation.create.success")
     #  redirect to: CurrentLogin::New
     #end

     #private def failure_action(operation)
     #  flash.failure = Rex.t(:"action.email_confirmation.create.failure")
     #  html NewPage, operation: operation
     #end
     # ...
   end
   ```

   `StartEmailConfirmation#user_email?` is `true` if the email is already registered to a user in the application.

   By default, the same action is performed for a user email as we would do for a non-registered email address. This is to prevent [username enumeration](https://www.troyhunt.com/everything-you-ever-wanted-to-know/).

   ---
   ```crystal
   # ->>> src/actions/email_confirmations/show.cr

   class EmailConfirmations::Show < BrowserAction
     # ...
     include Shield::EmailConfirmations::Show

     get "/email-confirmations/:email_confirmation_token" do
       run_operation
     end
     # ...
   end
   ```

   `Shield::EmailConfirmations::Show` is just a pass-through to avoid leaking email confirmation tokens to third parties, via the HTTP referer header.

   It verifies the token, retrieved from params, and sets it in session. It, then, redirects to the route responsible for creating or updating the user.

   ---
   ```crystal
   # ->>> src/actions/email_confirmations/edit.cr

   class EmailConfirmations::Update < BrowserAction
     # ...
     include Shield::EmailConfirmations::Update

     # If you are worried about users on mobile, you may want
     # to disable pinning an email confirmation to its IP address
     #skip :pin_email_confirmation_to_ip_address

     get "/email-confirmations/update" do
       run_operation
     end

     # What to do if token verification fails
     #
     #def do_verify_operation_failed(utility)
     #  flash.failure = Rex.t(:"action.misc.token_invalid")
     #  redirect to: New
     #end

     # What to do if `run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, user)
     #  flash.success = Rex.t(:"action.email_confirmation.update.success")
     #  redirect to: CurrentUser::Show
     #end

     # What to do if `run_operation` fails
     #
     #def do_run_operation_failed(operation)
     #  flash.failure = Rex.t(:"action.email_confirmation.update.failure")
     #  redirect to: CurrentUser::Edit
     #end
     # ...
   end
   ```

   `Shield::EmailConfirmations::Update` updates the email of an existing user, after they have successfully verified their email.

   ---
   ```crystal
   # ->>> src/actions/current_user/new.cr

   class CurrentUser::New < BrowserAction
     # ...
     include Shield::EmailConfirmationCurrentUser::New

     # If you are worried about users on mobile, you may want
     # to disable pinning an email confirmation to its IP address
     #skip :pin_email_confirmation_to_ip_address

     get "/account/new" do
       run_operation
     end

     # What to do if token verification fails
     #
     #def do_verify_operation_failed(utility)
     #  flash.failure = Rex.t(:"action.misc.token_invalid")
     #  redirect to: ::EmailConfirmations::New
     #end
     # ...
   end
   ```

   `Shield::EmailConfirmationCurrentUser::New` displays the user registration form if the email was successfully verified. Include this module, instead of `Shield::CurrentUser::New`, if you use email confirmations in your app.

   You may need to add `CurrentUser::NewPage` in `src/pages/current_user/new_page.cr`, containing your user registration form.

   The form should be `POST`ed to `CurrentUser::Create`, with the following parameters:

   - `password : String`

   You may skip this action if building an API.

   ---
   ```crystal
   # ->>> src/actions/current_user/create.cr

   class CurrentUser::Create < BrowserAction
     # ...
     include Shield::EmailConfirmationCurrentUser::Create

     # If you are worried about users on mobile, you may want
     # to disable pinning an email confirmation to its IP address
     #skip :pin_email_confirmation_to_ip_address

     post "/account" do
       run_operation
     end

     # What to do if token verification fails
     #
     #def do_verify_operation_failed(utility)
     #  flash.failure = Rex.t(:"action.misc.token_invalid")
     #  redirect to: ::EmailConfirmations::New
     #end

     # What to do if `run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, user)
     #  flash.success = Rex.t(:"action.current_user.create.success")
     #  redirect to: CurrentLogin::New
     #end

     # What to do if `run_operation` fails
     #
     #def do_run_operation_failed(operation)
     #  if operation.user_email?
     #    success_action(operation)
     #  else
     #    flash.failure = Rex.t(:"action.current_user.create.failure")
     #    html NewPage, operation: operation
     #  end
     #end
     # ...
   end
   ```
   
   `Shield::EmailConfirmationCurrentUser::Create` creates a user if their email was successfully verified. Include this module, instead of `Shield::CurrentUser::Create`, if you use email confirmations in your app.

   ---
   ```crystal
   # ->>> src/actions/current_user/show.cr

   class CurrentUser::Show < BrowserAction
     # ...
     include Shield::EmailConfirmationCurrentUser::Show

     get "/account" do
       html ShowPage, user: user
     end
     # ...
   end
   ```
   
   `Shield::EmailConfirmationCurrentUser::Show` displays information about the current user. Include this module, instead of `Shield::CurrentUser::Show`, if you use email confirmations in your app.

   ---
   ```crystal
   # ->>> src/actions/current_user/edit.cr

   class CurrentUser::Edit < BrowserAction
     # ...
     include Shield::EmailConfirmationCurrentUser::Edit

     get "/account/edit" do
       operation = UpdateCurrentUser.new(
         user,
         remote_ip: remote_ip?,
         current_login: current_login?
       )

       html EditPage, operation: operation
     end
     # ...
   end
   ```
   
   `Shield::EmailConfirmationCurrentUser::Edit` edits the current user. Include this module, instead of `Shield::CurrentUser::Edit`, if you use email confirmations in your app.

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
     include Shield::EmailConfirmationCurrentUser::Update

     patch "/account" do
       run_operation
     end

     # What to do if `run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, user)
     #  flash.success = success_message(operation)
     #
     #  if LuckyEnv.production? || operation.new_email.nil?
     #    redirect to: Show
     #  else
     #    redirect to: operation.credentials.not_nil!.url
     #  end
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
   
   `Shield::EmailConfirmationCurrentUser::Update` updates a user. Include this module, instead of `Shield::CurrentUser::Update`, if you use email confirmations in your app.

1. Set up emails:

   ```crystal
   # ->>> src/emails/email_confirmation_request_email.cr
   
   class EmailConfirmationRequestEmail < BaseEmail
     # ...
     def initialize(
       @operation : StartEmailConfirmation,
       @email_confirmation : EmailConfirmation
     )
     end

     # Sample message
     def text_body
       <<-MESSAGE
       Hi,

       You (or someone else) entered this email address while
       registering for a new <app name here> account, or updating their email
       address.

       To proceed to confirm your email, click the link below:

       #{EmailConfirmationCredentials.new(@operation, @email_confirmation).url}

       #{link_expiry_minutes.try do |expiry|
         "This email confirmation link will expire in #{expiry} minutes."
       end}

       If you did not initiate this request, ignore this email.

       Regards,
       <app name here>.
       MESSAGE
     end

     private def link_expiry_minutes
        @email_confirmation.status.span?.try(&.total_minutes.to_i)
     end
     # ...
   end
   ```

   This is a confirmation email sent to the new email address of a new or existing user. It should contain the email confirmation URL.

   ---
   ```crystal
   # ->>> src/emails/user_email_confirmation_request_email.cr
   
   class UserEmailConfirmationRequestEmail < BaseEmail
     # ...
     def initialize(@operation : StartEmailConfirmation)
     end

     # Sample message
     def text_body
       <<-MESSAGE
       Hi,

       You (or someone else) entered this email address while trying to
       register for a new <app name here> account, or update the email of
       an existing user.

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

   This email is sent to a valid email address that initiated email confirmation, if the email belongs to an existing user.
