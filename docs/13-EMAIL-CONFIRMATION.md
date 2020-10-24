## Email Confirmation

*Shield* offers email confirmations, for the purpose of verifying a new email address supplied by a user, either when registering for a new account, or while updating their exisiting account.

Email confirmation provides very little, if any, security benefits. It, however, improves usability by ensuring that and email address is valid, exists and is owned by the user supplying it.

This is particularly important, since email addresses are usually the only means to reset passwords. If a user supplied the wrong email address, and lost their password, they are out of luck.

[Read this](https://www.forbes.com/sites/ianmorris/2017/08/01/when-companies-dont-verify-email-addresses-this-is-what-happens/) for more reasons why email confirmation may be important.

### Setting up

1. Configure:

   ```crystal
   # ->>> config/shield.cr

   Shield.configure do |settings|
     # How long should email confirmation last before it expires?
     settings.email_confirmation_expiry = 1.hour
   end
   ```

1. Set up models:

   ```crystal
   # ->>> src/models/user.cr

   class User < BaseModel
     # ...
     include Shield::HasManyEmailConfirmations
     # ...
   end
   ```

   `Shield::HasManyEmailConfirmations` sets up a *one-to-many* association with the user model.

   ---
   ```crystal
   # ->>> src/models/email_confirmation.cr

   class EmailConfirmation < BaseModel
     # ...
     include Shield::EmailConfirmation

     table :email_confirmations do
       # You may add more columns here
     end
     # ...
   end
   ```

   `Shield::EmailConfirmation` adds the following columns:

   - `email : String`
   - `ended_at : Time?`
   - `ip_address : String`
   - `started_at : Time`
   - `status : EmailConfirmation::Status`
   - `token_digest : String`

   ...and sets up an optional one-to-many association with the `User` model.

   It removes *Lucky*'s default `created_at : Time` and `update_at : Time` columns.

   You may add other columns and associations specific to your application.

1. Set up the query:

   ```crystal
   # ->>> src/queries/email_confirmation_query.cr

   class EmailConfirmationQuery < EmailConfirmation::BaseQuery
     # ...
   end
   ```

1. Set up the migration:

   ```crystal
   # ->>> db/migrations/XXXXXXXXXXXXXX_create_email_confirmations.cr

   class CreateEmailConfirmations::VXXXXXXXXXXXXXX < Avram::Migrator::Migration::V1
     def migrate
       create table_for(EmailConfirmation) do
         # ...
         primary_key id : Int64

         add_belongs_to user : User?, on_delete: :cascade

         add email : String

         add token_digest : String
         add ip_address : String
         add started_at : Time
         add ended_at : Time?
         # ...
       end
     end

     def rollback
       drop table_for(EmailConfirmation)
     end
   end
   ```

   Add any columns you added to the model here.

1. Set up operations:

   ```crystal
   # ->>> src/operations/start_email_confirmation.cr

   class StartEmailConfirmation < Avram::BasicOperation
     # ...
     include Shield::StartEmailConfirmation
     # ...
   end
   ```

   `Shield::StartEmailConfirmation` kicks off the entire process of confirming a given email address. It receives `email : String` and an optional `user_id : Int64?` (for an existing user), and generates a link that it sends to the email address supplied.

   ---
   ```crystal
   # ->>> src/operations/end_email_confirmation.cr

   class EndEmailConfirmation < EmailConfirmation::SaveOperation
     # ...
     include Shield::EndEmailConfirmation
     # ...
   end
   ```

   `Shield::EndEmailConfirmation` marks an email confirmation inactive, to ensure it is never reused.

   ---
   ```crystal
   # ->>> src/operations/register_currrent_user.cr

   class RegisterCurrentUser < User::SaveOperation
     # ...
     include Shield::RegisterEmailConfirmationUser
     include Shield::SendWelcomeEmail

     # By default, *Shield* sets the status of all email confirmations to
     # `Ended` to mark them as inactive, without deleting them.
     #
     # Enable this to delete them from the database instead.
     #
     #include Shield::DeleteEmailConfirmationsAfterRegisterUser
     # ...
   end
   ```

   `Shield::RegisterEmailConfirmationUser` creates a new user after they have verified their email address. Include this module, instead of `Shield::RegisterUser`, if you use email confirmations in your app.

   ---
   ```crystal
   # ->>> src/operations/update_currrent_user.cr

   class UpdateCurrentUser < User::SaveOperation
     # ...
     include Shield::UpdateEmailConfirmationUser
     # ...
   end
   ```

   `Shield::UpdateEmailConfirmationUser` updates an existing user, but does not save the new email. It starts a new email confirmation for the user if their email changed.

   Include this module, instead of `Shield::UpdateUser`, if you use email confirmations in your app.

   ---
   ```crystal
   # ->>> src/operations/update_confirmed_email.cr

   class UpdateConfirmedEmail < User::SaveOperation
     # ...
     include Shield::UpdateConfirmedEmail

     # By default, *Shield* sets the status of all email confirmations to
     # `Ended` to mark them as inactive, without deleting them.
     #
     # Enable this to delete them from the database instead.
     #
     #include Shield::DeleteEmailConfirmationsAfterUpdateEmail
     # ...
   end
   ```

   `Shield::UpdateConfirmedEmail` updates an existing users email address, after they have verified their email.

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
     #  flash.keep.failure = "Your IP address has changed. Please try again."
     #  redirect to: EmailConfirmations::New
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
       html NewPage
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
     #  success_action(operation)
     #end

     # What to do if `run_operation` fails
     #
     #def do_run_operation_failed(operation)
     #  if operation.user_email?
     #     success_action(operation)
     #   else
     #     flash.failure = "Email confirmation request failed"
     #     html NewPage, operation: operation
     #   end
     #end

     #private def success_action(operation)
     #  flash.keep.success = "Done! Check your email for further instructions."
     #  redirect to: CurrentLogin::New
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

     param token : String

     get "/email-confirmations" do
       run_operation
     end
     # ...
   end
   ```

   `Shield::EmailConfirmations::Show` is just a pass-through to avoid leaking email confirmation tokens to third parties, via the HTTP referer header.

   It verifies the token, retrieved from params, and sets it in session. It, then, redirects to the route responsible for creating or updating the user.

   ---
   ```crystal
   # ->>> src/actions/email_confirmations/update.cr

   class EmailConfirmations::Update < BrowserAction
     # ...
     include Shield::EmailConfirmations::Update

     # If you are worried about users on mobile, you may want
     # to disable pinning an email confirmation to its IP address
     #skip :pin_email_confirmation_to_ip_address

     patch "/email-confirmations" do
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
     #  flash.keep.success = "Email changed successfully"
     #  redirect to: CurrentUser::Show
     #end

     # What to do if `run_operation` fails
     #
     #def do_run_operation_failed(operation)
     #  flash.failure = "Could not change email"
     #  html CurrentUser::EditPage, operation: operation
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
     #  flash.keep.failure = "Invalid token"
     #  redirect to: EmailConfirmations::New
     #end
     # ...
   end
   ```

   `Shield::EmailConfirmationCurrentUser::New` displays the user registration form if the email was successfully verified. Include this module, instead of `Shield::CurrentUser::New`, if you use email confirmations in your app.

   You may need to add `CurrentUser::NewPage` in `src/pages/current_user/new_page.cr`, containing your user registration form.

   The form should be `POST`ed to `CurrentUser::Create`, with the following parameters:

   - `password : String`
   - `password_confirmation : String`

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
     #  flash.keep.failure = "Invalid token"
     #  redirect to: EmailConfirmations::New
     #end

     # What to do if `run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, user)
     #  flash.keep.success = "Congratulations! Log in to access your account..."
     #  redirect to: CurrentLogin::New
     #end

     # What to do if `run_operation` fails
     #
     #def do_run_operation_failed(operation)
     #  if operation.user_email?
     #    success_action
     #  else
     #    flash.failure = "Could not create your account"
     #
     #    html NewPage,
     #      operation: operation,
     #      email_confirmation: operation.email_confirmation
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
       operation = UpdateCurrentUser.new(user, params)
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
   - `password_confirmation : String`

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
     #  if operation.new_email
     #    notice = "Account updated successfully. Check '#{
     #      operation.new_email}' for further instructions."
     #  else
     #    notice = "Account updated successfully"
     #  end
     #
     #  flash.keep.success = notice
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
   
   `Shield::EmailConfirmationCurrentUser::Update` updates a user. Include this module, instead of `Shield::CurrentUser::Update`, if you use email confirmations in your app.

1. Set up helpers:

   ```crystal
   # ->>> src/helpers/email_confirmation_helper.cr

   module EmailConfirmationHelper
    extend Shield::EmailConfirmationHelper
   end
   ```

1. Set up utilities:

   ```crystal
   # ->>> src/utilities/email_confirmation_session.cr

   class EmailConfirmationSession # Or `struct ...`
     # ...
     include Shield::EmailConfirmationSession

     # By default, *Shield* sets the status of an email confirmation to
     # `Expired` when it expired, without deleting it.
     #
     # Enable this to delete it instead
     #include Shield::DeleteEmailConfirmationIfExpired
     # ...
   end
   ```

   `Shield::EmailConfirmationSession` is a wrapper around *Lucky* sessions that deals with session keys and values for email confirmations, and handles verification of email confirmation tokens retrieved from session.

1. Set up emails:
   
   `EmailConfirmationRequestEmail`:

   This is a confirmation email sent to the new email address of a new or existing user. It should contain the email confirmation URL.

   ```crystal
   # ->>> src/emails/email_confirmation_request_email.cr
   
   class EmailConfirmationRequestEmail < BaseEmail
     # ...
     def initialize(
       @operation : StartEmailConfirmation,
       @email_confirmation : EmailConfirmation
     )
     end
     # ...
   end
   ```

   *Sample Message*:

   ```crystal
   # ->>> src/emails/email_confirmation_request_email.cr
   
   class EmailConfirmationRequestEmail < BaseEmail
     # ...
     def text_body
       <<-MESSAGE
       Hi,

       You (or someone else) entered this email address while
       registering for a new <app name here> account, or updating their email
       address.

       To proceed to confirm your email, click the link below:

       #{EmailConfirmationHelper.email_confirmation_url(@email_confirmation, @operation)}

       This email confirmation link will expire in #{Shield.settings.email_confirmation_expiry.total_minutes.to_i} minutes.

       If you did not initiate this request, ignore this email.

       Regards,
       <app name here>.
       MESSAGE
     end
     # ...
   end
   ```

   ---
   `UserEmailConfirmationRequestEmail`:

   This email is sent to a valid email address that initiated email confirmation, if the email belongs to an existing user.

   ```crystal
   # ->>> src/emails/user_email_confirmation_request_email.cr
   
   class UserEmailConfirmationRequestEmail < BaseEmail
     # ...
     def initialize(@operation : StartEmailConfirmation)
     end
     # ...
   end
   ```

   *Sample Message*:

   ```crystal
   # ->>> src/emails/user_email_confirmation_request_email.cr
   
   class UserEmailConfirmationRequestEmail < BaseEmail
     # ...
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
