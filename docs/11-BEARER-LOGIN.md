## *Bearer* login (API tokens)

*Shield* enables authentication via access tokens, per [RFC 6750](https://tools.ietf.org/html/rfc6750). Any registered user may create *bearer login*s, and assign capabilities to them in the form of `scopes`.

In *Shield*, every action represents a single scope, which, if included in a *bearer login*'s assigned `scopes`, would allow a client possessing that *bearer login*'s token to access that action.

An action's scope name is the action's class name underscored, with `::` replaced with `.`. For instance, `Api::Posts::Index` becomes `api.posts.index`, `Api::CurrentUser::Show` becomes `api.current_user.show`, etc.

When a user creates a *bearer login*, they generate a token, and delegate some or all of their rights, to this token. Any client in possession of the token may access the application on behalf of the user, without needing login credentials of their own.

Tokens are salted and hashed (SHA-256) before being saved to the database, so users are expected to copy and save them as soon as they are generated.

Shield expects clients to pass a token in their `Authorization` header, with the `Bearer` authentication scheme, thus: `Authorization: Bearer <TOKEN>`.

When *Shield* receives a request from a client, it retrieves this `<TOKEN>` from its headers, and verifies that it exists in the database, and that it has not been revoked or expired.

If the token is successfully verified, *Shield* further checks that the token has the required `scopes` to access the current action.

Finally, *Shield* checks that the user that generated this token has the right to access the current action. This check is based on the authorization rules you set up in section *08-AUTHORIZATION.md*.

Effectively, a user cannot generate a valid *bearer login* token for an action they do not, originally, have access to.

### API logins with regular passwords

*Shield* supports API logins with regular passwords, if you expose that endpoint in you API. However, *sessions* are not used at all for API logins.

Instead, *Shield* generates a temporary token for every successful login, and expects clients to pass such token in the `Authorization` header, as with bearer logins.

This token is revoked when the user logs out.

### Setting up

1. Configure:

   ```crystal
   # ->>> config/shield.cr

   Shield.configure do |settings|
     # ...
     # How long should bearer login last before it expires?
     #settings.bearer_login_expiry = 90.days # Set to `nil` to disable

     # Email confirmation URL to mail to user (useful for API-only apps)
     #settings.email_confirmation_url = ->(token : String) do
     #  "https://my-frontend-app.com/auth/ec?token=#{token}"
     #end

     # Password reset URL to mail to user (useful for API-only apps)
     #settings.password_reset_url = ->(token : String) do
     #  "https://my-frontend-app.com/auth/pr?token=#{token}"
     #end
     # ...
   end
   ```

1. Set up models:

   ---
   ```crystal
   # ->>> src/models/bearer_login.cr

   class BearerLogin < BaseModel
     # ...
     include Shield::BearerLogin

     table :bearer_logins do
       # You may add more columns here
     end
     # ...
   end
   ```

   `Shield::BearerLogin` adds the following columns:
   
   - `active_at : Time`
   - `inactive_at : Time?`
   - `name : String`
   - `scopes : Array(String)`
   - `token_digest : String`

   It removes *Lucky*'s default `created_at : Time` and `update_at : Time` columns.

   You may add other columns and associations specific to your application.

   ---
   ```crystal
   # ->>> src/models/user.cr

   class User < BaseModel
     # ...
     include Shield::HasManyBearerLogins
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/models/user_settings.cr

   struct UserSettings
     # ...
     include Shield::BearerLoginUserSettings
     # ...
   end
   ```

   `Shield::BearerLoginUserSettings` adds the following properties:

   - `bearer_login_notify : Bool`

   ---
   \* *Skip this if using `UserSettings`* \*

   ```crystal
   # ->>> src/models/user_options.cr

   class UserOptions < BaseModel
     # ...
     include Shield::BearerLoginUserOptionsColumns
     # ...
   end
   ```

   `Shield::BearerLoginUserOptionsColumns` adds the following columns:

   - `bearer_login_notify : Bool`

1. Set up the migration:

   ```crystal
   # ->>> db/migrations/XXXXXXXXXXXXXX_create_bearer_logins.cr

   class CreateBearerLogins::VXXXXXXXXXXXXXX < Avram::Migrator::Migration::V1
     def migrate
       create :bearer_logins do
         # ...
         primary_key id : Int64

         add_timestamps
         add_belongs_to user : User, on_delete: :cascade

         add name : String
         add scopes : Array(String)

         add token_digest : String
         add active_at : Time
         add inactive_at : Time?
         # ...
       end
     end

     def rollback
       drop :bearer_logins
     end
   end
   ```

   Add any columns you added to the model here.

   ---
   \* *Skip this if using `UserSettings`* \*

   ```crystal
   # ->>> db/migrations/XXXXXXXXXXXXXX_add_bearer_login_user_options.cr

   class AddBearerLoginUserOptions::VXXXXXXXXXXXXXX < Avram::Migrator::Migration::V1
     def migrate
       alter :user_options do
         add bearer_login_notify : Bool, fill_existing_with: true
       end
     end

     def rollback
       alter :user_options do
         remove :bearer_login_notify
       end
     end
   end
   ```

1. Set up operations:

   All operations are already set up. You may reopen an operation to add new functionality.

   ```crystal
   # ->>> src/operations/create_current_user_bearer_login.cr

   class CreateCurrentUserBearerLogin < BearerLogin::SaveOperation
     # ...
   end
   ```

   `CreateCurrentUserBearerLogin` receives `name : String` and `scopes : Array(String)` parameters, and creates a database entry with a unique ID and hashed token.

   ---
   ```crystal
   # ->>> src/operations/revoke_bearer_login.cr

   class RevokeBearerLogin < BearerLogin::SaveOperation
     # ...
   end
   ```

   `RevokeBearerLogin` updates the relevant columns in the database to mark a given *bearer login* as inactive.

   ---
   ```crystal
   # ->>> src/operations/delete_bearer_login.cr

   class DeleteBearerLogin < BearerLogin::DeleteOperation
     # ...
   end
   ```

   `DeleteBearerLogin` actually deletes a given *bearer login* from the database. Use this instead of `RevokeBearerLogin` if you intend to actually delete bearer logins, rather than mark them as inactive.

1. Set up actions:

   ```crystal
   # ->>> src/actions/api_action.cr

   abstract class ApiAction < Lucky::Action
     # ...
     route_prefix "/api/v0"

     # If you are worried about users on mobile, you may want
     # to disable pinning a login to its IP address
     #skip :pin_login_to_ip_address

     # What to do if user is **not** logged in
     # but the action requires user to be logged in.
     #
     #def do_require_logged_in_failed
     #  json({status: "failure", message: Rex.t(:"action.pipe.not_logged_in")})
     #end

     # What to do if user is logged in but the action
     # requires user to **not** be logged in.
     #
     #def do_require_logged_out_failed
     #  json({status: "failure", message: Rex.t(:"action.pipe.not_logged_out")})
     #end

     # What to do if user is not allowed to perform action
     #
     #def do_check_authorization_failed
     #  json({
     #    status: "failure",
     #    message: Rex.t(:"action.pipe.authorization_failed")
     #  })
     #end

     # What to do when a logged in user's IP address changes, if the
     # action requires the user's IP to match the IP they used to
     # log in.
     #
     #def do_pin_login_to_ip_address_failed
     #  json({
     #    status: "failure",
     #    message: Rex.t(:"action.pipe.ip_address_changed")
     #  })
     #end

     # What to do when a user's IP address changes in a password reset, if the
     # action requires the user's IP to match the IP with which they requested
     # the password reset.
     #
     #def do_pin_password_reset_to_ip_address_failed
     #  json({
     #    status: "failure",
     #    message: Rex.t(:"action.pipe.ip_address_changed")
     #  })
     #end

     # What to do when a user's IP address changes in an email confirmationo, if the
     # action requires the user's IP to match the IP with which they started
     # the email confirmation.
     #
     #def do_pin_email_confirmation_to_ip_address_failed
     #  json({
     #    status: "failure",
     #    message: Rex.t(:"action.pipe.ip_address_changed")
     #  })
     #end
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/actions/current_user/bearer_logins/new.cr

   class CurrentUser::BearerLogins::New < BrowserAction
     # ...
     include Shield::CurrentUser::BearerLogins::New

     get "/account/bearer-logins/new" do
       operation = CreateCurrentUserBearerLogin.new(
         user: user,
         allowed_scopes: BearerScope.action_scopes.map(&.name)
       )

       html NewPage, operation: operation
     end
     # ...
   end
   ```

   You may need to add `CurrentUser::BearerLogins::NewPage` in `src/pages/current_user/bearer_logins/new_page.cr`, containing your *bearer login* form.

   The form should be `POST`ed to `CurrentUser::BearerLogins::Create`, with the following parameters:

   - `name : String`
   - `scopes : Array(String)`

   ---
   ```crystal
   # ->>> src/actions/current_user/bearer_logins/create.cr

   class CurrentUser::BearerLogins::Create < BrowserAction
     # ...
     include Shield::CurrentUser::BearerLogins::Create

     post "/account/bearer-logins" do
       run_operation
     end

     # What to do if `run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, bearer_login)
     #  flash.success = Rex.t(:"action.current_user.bearer_login.create.success")
     #  redirect to: Show.with(bearer_login_id: bearer_login.id)
     #end

     # What to do if `run_operation` fails
     #
     #def do_run_operation_failed(operation)
     #  flash.failure = Rex.t(:"action.current_user.bearer_login.create.failure")
     #  html NewPage, operation: operation
     #end
     # ...
   end
   ```

   You may need to add `CurrentUser::BearerLogins::ShowPage` in `src/pages/current_user/bearer_logins/show_page.cr`, that displays the generated login token, thus: `BearerToken.new(operation, bearer_login).to_s`

   ---
   ```crystal
   # ->>> src/actions/current_user/bearer_logins/index.cr

   class CurrentUser::BearerLogins::Index < BrowserAction
     # ...
     include Shield::CurrentUser::BearerLogins::Index

     param page : Int32 = 1

     get "/account/bearer-logins" do
       html IndexPage, bearer_logins: bearer_logins, pages: pages
     end
     # ...
   end
   ```

   You may need to add `CurrentUser::BearerLogins::IndexPage` in `src/pages/current_user/bearer_logins/index_page.cr`, that displays all of the current user's active tokens, ideally with buttons to revoke them.

   ---
   ```crystal
   # ->>> src/actions/bearer_logins/destroy.cr

   class BearerLogins::Destroy < BrowserAction
     # ...
     # By default, *Shield* marks the bearer login as inactive,
     # without deleting it.
     #
     # To delete it, use `Shield::BearerLogins::Delete` instead.
     include Shield::BearerLogins::Destroy

     delete "/bearer-logins/:bearer_login_id" do
       run_operation
     end

     # What to do if `run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, login)
     #  flash.success = Rex.t(:"action.bearer_login.destroy.success")
     #  redirect to: Index
     #end

     # What to do if `run_operation` fails
     #
     #def do_run_operation_failed(operation)
     #  flash.failure = Rex.t(:"action.bearer_login.destroy.failure")
     #  redirect_back fallback: Index
     #end
     # ...
   end
   ```

   `Shield::BearerLogins::Destroy` is responsible for revoking bearer logins. Revoke buttons/links must point to this action.

1. Set up emails:

   ```crystal
   # ->>> src/emails/bearer_login_notification_email.cr

   class BearerLoginNotificationEmail < BaseEmail
     # ...
     def initialize(
       @operation : Shield::CreateBearerLogin,
       @bearer_login : BearerLogin
     )
     end

     # Sample message
     def text_body
       <<-MESSAGE
       Hi User ##{@bearer_login.user.id},

       This is to let you know that a new bearer login token was created for your
       <app name here> account.

       =====
       Date: #{@bearer_login.active_at.to_s("%d %B, %Y, %l:%M %P")}
       =====

       If you did not do this yourself, let us know immediately in your reply
       to this message. Otherwise, you may safely ignore this email.

       Regards,
       <app name here>.
       MESSAGE
     end
     # ...
   end
   ```

   Each registered user has the option to receive this notification email when they (or someone else) creates a bearer login for their account.

   Set this email up if you set up user options.

### Action helpers

`ApiAction` adds in the following helpers, as counterparts to those provided in `BrowserAction`.

- `#bearer_logged_in?`
- `#bearer_logged_out?`
- `#current_bearer_login?`
- `#current_bearer_login`
- `#current_bearer?`
- `#current_bearer`

Other helpers are provided as follows:

- `#current_user_or_bearer`:

   Returns `#current_user` if available, otherwise returns `#current_bearer`. This is useful for dealing with the current user in APIs.

### Authentication actions via API endpoints

*Shield* allows all authentication actions that are possible via the web browser to be done via API, if the application chooses to expose those endpoints.

For instance, an application may allow a user to register or log in or start a password reset, from API endpoints exposed for such purposes.

*Shield* even supports creating bearer logins from APIs. A user may log in with a regular password via API, and use the token they receive to create bearer logins. They could even create a bearer login via the browser, assigning it `scopes` that allow it to create other bearer logins via API.

For these purposes, *Shield* provides the following modules:

#### Actions

- `Shield::Api::BearerLogins::Create`
- `Shield::Api::BearerLogins::Destroy`
- `Shield::Api::BearerLogins::Delete`
- `Shield::Api::BearerLogins::Index`
- `Shield::Api::CurrentLogin::Create`
- `Shield::Api::CurrentLogin::Destroy`
- `Shield::Api::CurrentLogin::Delete`
- `Shield::Api::CurrentUser::Create`
- `Shield::Api::CurrentUser::Show`
- `Shield::Api::CurrentUser::Update`
- `Shield::Api::CurrentUser::BearerLogins::Create`
- `Shield::Api::CurrentUser::BearerLogins::Show`
- `Shield::Api::CurrentUser::BearerLogins::Update`
- `Shield::Api::EmailConfirmationCurrentUser::Create`
- `Shield::Api::EmailConfirmationCurrentUser::Show`
- `Shield::Api::EmailConfirmationCurrentUser::Update`
- `Shield::Api::EmailConfirmationCurrentUser::Verify`
- `Shield::Api::EmailConfirmations::Create`
- `Shield::Api::EmailConfirmations::Update`
- `Shield::Api::PasswordResets::Create`
- `Shield::Api::PasswordResets::Update`
- `Shield::Api::PasswordResets::Verify`
- `Shield::Api::SkipAuthenticationCache`

If your application decides to allow any of these functionalities via its API, the modules above should be `include`d in their respective API actions.

### Other Types

1. Actions:

   - `Shield::Api::Logins::Delete`
   - `Shield::Api::Logins::Destroy`
   - `Shield::Api::Logins::Index`
   - `Shield::Api::Users::Create`
   - `Shield::Api::Users::Delete`
   - `Shield::Api::Users::Destroy`
   - `Shield::Api::Users::Index`
   - `Shield::Api::Users::Show`
   - `Shield::Api::Users::Update`

   `Shield::Api::Users::*` actions are reserved for situations where admins would like to perform certain operations on other registered users.

### Rate limiting

*Shield* has no API rate limiting implementation yet. For now, applications may achieve this via a reverse proxy (eg *Nginx*), or *Crystal* shards (eg [Defense](https://github.com/defense-cr/defense)).

### API security tips

- Always use HTTPS
- Only expose endpoints you absolutely need.
