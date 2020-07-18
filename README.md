# Shield

*Shield* is a comprehensive security solution for [*Lucky* framework](https://luckyframework.org). It features robust authentication and authorization, including:

- User registrations
- Logins and logouts
- Remember logins
- Login notifications (per-user setting)
- Password change notifications (per-user setting)
- Password resets

...and more

*Shield* securely hashes password reset and login tokens, before saving them to the database.

User IDs are never saved in session. Instead, each password reset or login gets a unique ID and token, which is saved in session, and checked against corresponding values in the database.

On top of these, *Shield* offers seamless integration with your application. For the most part, `include` a bunch of `module`s in the appropriate `class`es, and you are good to go!

## Installation

*Shield* requires *Lucky* version **0.23.0** or newer.

1. Add the dependency to your `shard.yml`:

   ```yaml
   # ->>> shard.yml

   # ...
   dependencies:
     shield:
       github: GrottoPress/shield
       branch: master
   # ...
   ```

1. Run `shards install`

1. In `src/app.cr` of your application (or whatever your app's bootstrap file is), `require "shield"`:

```crystal
# ->>> src/app.cr

# ...
require "shield"
# ...
```

## Usage

### Configuration

*Shield* uses *Habitat*, which comes bundled with *Lucky*, for configuration.

```crystal
# ->>> config/shield.cr

Shield.configure do |settings|
  # How long login should be remebered?
  settings.login_expiry = 30.days

  # Required minimum length of password
  settings.password_min_length = 12

  # Require lowercase letter in password?
  settings.password_require_lowercase = true

  # Require uppercase letter in password?
  settings.password_require_uppercase = true

  # Require number in password?
  settings.password_require_number = true

  # Require special character in password?
  settings.password_require_special_char = true

  # How long should a password reset last before it expires?
  settings.password_reset_expiry = 30.minutes
end
```

### Type Names

*Shield* assumes the following type names in your application:

#### Models

- `Login`
- `PasswordReset`
- `User`
- `UserOptions`

#### Queries

- `LoginQuery`
- `PasswordResetQuery`
- `UserQuery`
- `UserOptionsQuery`

#### Emails

- `GuestPasswordResetRequestEmail`
- `LoginNotificationEmail`
- `PasswordChangeNotificationEmail`
- `PasswordResetRequestEmail`

#### Operations

- `EndPasswordReset`
- `LogUserIn`
- `LogUserOut`
- `ResetPassword`
- `SaveCurrentUser`
- `SaveUser`
- `SaveUserOptions`
- `StartPasswordReset`

#### Actions

- `CurrentUser::Show`
- `Logins::New`
- `PasswordResets::Edit`
- `PasswordResets::Show`

If you would rather name your types differently, set aliases for your own types to these ones, thus:

```crystal
# ->>> config/types.cr

alias User = MyUserModel
alias UserQuery = MyUserQuery
# ...
```

Then `require` this alias file wherever the compiler yells about a missing type.

### General Setup

1. Set up the base model:

   ```crystal
   # ->>> src/models/base_model.cr

   abstract class BaseModel < Avram::Model
     # ...
     include Shield::Model
     # ...
   end
   ```
   
1. Set up base actions:

   ```crystal
   # ->>> src/actions/browser_action.cr

   abstract class BrowserAction < Lucky::Action
     # ...
     include Shield::Action

     # What to do if user is **not** logged in
     # but the action requires user to be logged in.
     #
     #private def require_logged_in_action
     #  flash.failure = "You are not logged in"
     #  redirect to: Logins::New
     #end

     # What to do if user is logged in but the action
     # requires user to **not** be logged in.
     #
     #private def require_logged_out_action
     #  flash.info = "You are already logged in"
     #  redirect_back fallback: CurrentUser::Show
     #end

     # What to do if user is not allowed to perform action
     #
     #private def not_authorized_action(user, action, record)
     #  flash.failure = "You are not allowed to perform this action!"
     #  redirect to: CurrentUser::Show
     #end
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/actions/api_action.cr

   abstract class ApiAction < Lucky::Action
     # ...
     include Shield::Action

     # What to do if user is **not** logged in
     # but the action requires user to be logged in.
     #
     #private def require_logged_in_action
     #  flash.failure = "You are not logged in"
     #  redirect to: Logins::New
     #end

     # What to do if user is logged in but the action
     # requires user to **not** be logged in.
     #
     #private def require_logged_out_action
     #  flash.info = "You are already logged in"
     #  redirect_back fallback: CurrentUser::Show
     #end

     # What to do if a user is not allowed to perform action
     #
     #private def not_authorized_action(user, action, record)
     #  flash.failure = "You are not allowed to perform this action!"
     #  redirect to: CurrentUser::Show
     #end
     # ...
   end
   ```

### User

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
   - `password_hash : String`
   
   ...and sets up the relevant associations with other *Shield* models.

   You may add other columns and associations specific to your application.

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
         add password_hash : String
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
   # ->>> src/operations/save_currrent_user.cr

   class SaveCurrentUser < User::SaveOperation
     # ...
     include Shield::SaveCurrentUser
     # ...
   end
   ```

   There's also `Shield::SaveUser`, but that is reserved for saving users in other scenarios, such as an admin adding a new user.

   `Shield::SaveCurrentUser` is what should be used for user self-registration.

   `Shield::SaveCurrentUser` saves `email`, `password` and user options. If you added other columns and associations to the model, you may have to add callbacks for dealing with those.

1. Set up actions:

   ```crystal
   # ->>> src/actions/current_user/new.cr

   class CurrentUser::New < BrowserAction
     # ...
     include Shield::NewCurrentUser

     get "/sign-up" do
       html NewPage
     end
     # ...
   end
   ```

   You may need to add `CurrentUser::NewPage` in `src/pages/current_user/new_page.cr`, containing your user registration form.

   The form should be `POST`ed to `CurrentUser::Create`, with the following parameters:

   - `email : String`
   - `password : String`
   - `password_confirmation : String`

   You may skip this action if building an API.

   ---
   ```crystal
   # ->>> src/actions/current_user/create.cr

   class CurrentUser::Create < BrowserAction
     # ...
     include Shield::CreateCurrentUser

     post "/sign-up" do
       save_current_user
     end

     # What to do if `save_current_user` succeeds
     #
     #private def success_action(operation, user)
     #  flash.success = "User added successfully"
     #  redirect to: New
     #end

     # What to do if `save_current_user` fails
     #
     #private def failure_action(operation)
     #  flash.failure = "Could not add user"
     #  html NewPage, operation: operation
     #end
     # ...
   end
   ```

### User Options

1. Set up the model:

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
   
   - `login_notify : Bool`
   - `password_notify : Bool`
   
   ...and sets up a one-to-one association with the `User` model.

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
         add_belongs_to user : User, on_delete: :cascade

         add login_notify : Bool
         add password_notify : Bool
         # ...
       end

       # This sets a "UNIQUE" constraint on the foreign key (user_id)
       execute <<-SQL
       ALTER TABLE #{table_for(UserOptions)} ADD CONSTRAINT
       #{table_for(UserOptions)}_user_id_unique UNIQUE (user_id);
       SQL
     end

     def rollback
       drop table_for(UserOptions)
     end
   end
   ```

   Add any columns you added to the model here.

1. Set up operations:

   ```crystal
   # ->>> src/operations/save_user_options.cr

   class SaveUserOptions < UserOptions::SaveOperation
     # ...
     include Shield::SaveUserOptions
     # ...
   end
   ```

   `Shield::SaveUserOptions` saves `login_notify` and `password_notify`. If you added other columns and associations to the model, you may have to add callbacks for dealing with those.

1. Set up actions:

   User options do not have its own actions, since it is an extension of the `User` model in its own table.

   Operations and actions related to the `User` model already take care of saving user options.

   User edit forms, are therefore, required to include user options parameters:

   - `login_notify : Bool`
   - `password_notify : Bool`

### Login

1. Set up the model

   ```crystal
   # ->>> src/models/login.cr

   class Login < BaseModel
     # ...
     include Shield::Login

     table :logins do
       # You may add more columns here
     end
     # ...
   end
   ```

   `Shield::Login` adds the following columns:
   
   - `ended_at : Time?`
   - `ip_address : Socket::IPAddress?`
   - `started_at : Time`
   - `token_hash : String`
   
   ...and sets up a one-to-many association with the `User` model.

   It removes *Lucky*'s default `created_at : Time` and `update_at : Time` columns.

   You may add other columns and associations specific to your application.

1. Set up the migration:

   ```crystal
   # ->>> db/migrations/XXXXXXXXXXXXXX_create_login.cr

   class CreateLogin::VXXXXXXXXXXXXXX < Avram::Migrator::Migration::V1
     def migrate
       create table_for(Login) do
         # ...
         primary_key id : Int64

         add_belongs_to user : User, on_delete: :cascade

         add token_hash : String
         add ip_address : String?
         add started_at : Time
         add ended_at : Time?
         # ...
       end
     end

     def rollback
       drop table_for(Login)
     end
   end
   ```

   Add any columns you added to the model here.

1. Set up operations:

   ```crystal
   # ->>> src/operations/log_user_in.cr

   class LogUserIn < Login::SaveOperation
     # ...
     include Shield::LogUserIn
     # ...
   end
   ```

   `Shield::LogUserIn` receives `email`, `password` and `remember_login` parameters, and creates a login entry with a unique ID and hashed token in the database.

   For a client to be considered logged in, it must present a matching login ID and token from session.

   ---
   ```crystal
   # ->>> src/operations/log_user_out.cr

   class LogUserOut < Login::SaveOperation
     # ...
     include Shield::LogUserOut
     # ...
   end
   ```

   `Shield::LogUserOut` deletes session and cookie values related to the login, and updates the relevant columns in the database to mark the login as inactive.

1. Set up actions:

   ```crystal
   # ->>> src/actions/logins/new.cr

   class Logins::New < BrowserAction
     # ...
     include Shield::NewLogin

     get "/sign-in" do
       html NewPage
     end
     # ...
   end
   ```

   You may need to add `Logins::NewPage` in `src/pages/logins/new_page.cr`, containing your user login form.

   The form should be `POST`ed to `Logins::Create`, with the following parameters:

   - `email : String`
   - `password : String`
   - `remember_login : Bool`

   You may skip this action if building an API.

   ---
   ```crystal
   # ->>> src/actions/logins/create.cr

   class Logins::Create < BrowserAction
     # ...
     include Shield::CreateLogin

     post "/sign-in" do
       log_user_in
     end

     # What to do if `log_user_in` succeeds
     #
     #private def success_action(operation, login)
     #  flash.success = "Successfully logged in"
     #  redirect_back fallback: CurrentUser::Show
     #end

     # What to do if `log_user_in` fails
     #
     #private def failure_action(operation)
     #  flash.failure = "Invalid email or password"
     #  html NewPage, operation: operation
     #end
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/actions/logins/destroy.cr

   class Logins::Destroy < BrowserAction
     # ...
     include Shield::DestroyLogin

     get "/sign-out" do
       log_user_out
     end

     # What to do if `log_user_out` succeeds
     #
     #private def success_action(operation, login)
     #  flash.info = "Logged out. See ya!"
     #  redirect to: New
     #end

     # What to do if `log_user_out` fails
     #
     #private def failure_action(operation, login)
     #  flash.failure = "Something went wrong"
     #  redirect to: CurrentUser::Show
     #end
     # ...
   end
   ```

### Password Reset

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
   - `ip_address : Socket::IPAddress?`
   - `started_at : Time`
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
         add ip_address : String?
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

   `Shield::StartPasswordReset` receives a `user_email` parameter, generates a token, sends email, and saves the relevant values in the database.

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

   - `user_email : String`

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

### Other Actions

The following `module`s are available for inclusion in their respective actions, if needed:

- `Shield::NewUser` (for `Users::New`)
- `Shield::CreateUser` (for `Users::Create`)
- `Shield::ShowCurrentUser` (for `CurrentUser::Show`)
- `Shield::ShowUser` (for `Users::Show`)
- `Shield::UpdateUser` (for `Users::Update`)

### Emails

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

       #{@password_reset.url(@operation.token)}

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

   This email sent to a valid email address that requested a password reset, but the email did not belong to any registered user of your application.

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

### Authorization

`Shield::Model` adds in `Shield::Authorization`, which allows a model to define what actions a registered user is authorized to take on that model.

1. Set up models:

   ```crystal
   # ->>> src/models/post.cr

   class Post < BaseModel
     # ...
     # Allow only "admin" users to delete any given post
     authorize :delete do |user, post|
       user.level.admin?
     end

     # Allow only "admin" users and the post author, to update
     # a given post.
     authorize :update do |user, post|
       user.level.admin? || user.id == post.try(&.author!.id)
     end

     # Allow anyone to create or read any post
     authorize :create, :read do |user, post|
       true
     end
     # ...
   end
   ```

   `.authorize` accepts a list of authorized actions, and yields the user requesting authorization and the record (or nil).

   The block passed to `.authorize` must return a `Bool` -- `true` to authorize the actions, or `false` to deny them. The default is to deny (`false`).

   There are 4 possible authorized actions:

   - `Shield::AuthorizedAction::Read`
   - `Shield::AuthorizedAction::Create`
   - `Shield::AuthorizedAction::Update`
   - `Shield::AuthorizedAction::Delete`

   Check whether a given user is allowed to perform a given action:

   ```crystal
   user = UserQuery.find(1)
   post = PostQuery.find(2)

   # Equivalent to `post.allow?(user, :read)`
   user.can?(:read, post) # <= `true`

   # Here, we are checking authorization for `Post` class, instead
   # of a specific post instance.
   #
   # Equivalent to `Post.allow?(user, :read)`
   user.can?(:create, Post) # <= `true`
   ```

1. Set up *Lucky* actions:

   By default, all *Lucky* actions are required to check authorization for the current user, by calling `#authorize`. This should be the first call in the block passed to the route's macro:

   ```crystal
   # ->>> src/actions/posts/show.cr

   class Posts::Show < BrowserAction
     # ...
     get "/posts/:post_id" do
       authorize(:read, post) # <=
       html ShowPage, post: post
     end

     private def post
       PostQuery.find(post_id)
     end
     # ...
   end
   ```

   ```crystal
   # ->>> src/actions/posts/new.cr

   class Posts::New < BrowserAction
     # ...
     get "/posts/new" do
       authorize(:create, Post) # <=
       html NewPage
     end
     # ...
   end
   ```

   A *Lucky* action raises a `Shield::NoAuthorizationError` if `#authorize` is not called. You may skip this requirement by calling `skip :require_authorization`.
   
   Authorization is always skipped if the current user is not logged in. If you wish to deny access for such a user, use the `before :require_logged_in` pipe.

   `#authorize` defers to the passed model/record to check if the current user is allowed to perform the requested action. If authorization fails, `#not_authorized_action` (which you set up in the base *Lucky* actions) is called.

### Action Helpers

`Shield::Action` adds in the following helpers:

- `#authorize`:

    Checks if the current user is allowed to perform the requested action on the given model or record.

- `#authorize!`:

    Like `#authorize`, but raises `Shield::NotAuthorizedError` if current user is not allowed to perform the requested action.

- `#current_user`:

    Returns the current logged-in user, or `nil` if the user is not logged in.

- `#current_user!`:

    Equivalent to `current_user.not_nil!`.

- `#logged_in?`:

    Returns true if current user is logged in.

- `#logged_out?`:

    Returns true if current user is **not** logged in. It is the inverse of `#logged_in?`

- `#previous_page`:

    Returns the previous page URL, retrieved from session rather than from request headers.

- `#remote_ip`:

    Returns the client's IP address as `Socket::IPAddress?`.

## Development

Run tests with `docker-compose -f spec/docker-compose.yml run --rm spec`. If you need to update shards before that, run `docker-compose -f spec/docker-compose.yml run --rm shards`.

If you would rather run tests on your local machine (ie, without docker), create a `.env.sh` file:

```bash
#!bin/bash

export APP_DOMAIN=http://localhost:5000
export DATABASE_URL='postgres://postgres:password@localhost:5432/shield_spec'
export SECRET_KEY_BASE='XeqAgSy5QQ+dWe8ruOBUMrz9XPbPZ7chPVtz2ecDGss='
export SERVER_HOST='0.0.0.0'
export SERVER_PORT=5000
```

Update the file with your own details. Then run tests with `source .env.sh && crystal spec`.

## Contributing

1. [Fork it](https://github.com/your-github-user/shield/fork)
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Create a new Pull Request

## Security

Kindly report suspected security vulnerabilities in private, via contact details outlined in this repository's `.security.txt` file.
