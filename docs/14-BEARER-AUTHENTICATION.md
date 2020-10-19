## *Bearer* Authentication (API tokens)

*Shield* enables authentication via access tokens, per [RFC 6750](https://tools.ietf.org/html/rfc6750). Any registered user may create *bearer login*s, and assign capabilities to them in the form of `scopes`.

In *Shield*, every action represents a single scope, which, if included in a *bearer login*'s assigned `scopes`, would allow a client possessing that *bearer login*'s token to access that action.

An action's scope name is the action's class name underscored, with `::` replaced with `.`. For instance, `Api::Posts::Index` becomes `api.posts.index`, `Api::CurrentUser::Show` becomes `api.current_user.show`, etc.

When a user creates a *bearer login*, they generate a token, and delegate some or all of their rights, to this token. Any client in possession of the token may access the application on behalf of the user, without needing login credentials of their own.

A token is never saved in its plain form, so users are expected to copy and save them as soon as they are generated.

Shield expects clients to pass a token in their `Authorization` header, with the `Bearer` authentication scheme, thus: `Authorization: Bearer <TOKEN>`.

When *Shield* receives a request from a client, it retrieves this `<TOKEN>` from its headers, and verifies that it exists in the database (salted SHA-256), and that it has not been revoked or expired.

If the token is successfully verified, *Shield* further checks that the token has the required `scopes` to access the current action.

Finally, *Shield* checks that the user that generated this token has the right to access the current action. This check is based on the authorization rules you set up in section *12-AUTHORIZATION.md*.

Effectively, a user cannot generate a valid *bearer login* token for an action they do not, originally, have access to.

### API logins with regular passwords

*Shield* supports API logins with regular passwords, if you expose that endpoint in you API. However, *sessions* are not used at all for API logins.

Instead, *Shield* generates a temporary token for every successful login, and expects clients to pass such token in the `Authorization` header, as with bearer logins.

This token is revoked when the user logs out.

### Setting up

1. Set up the model

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
   
   - `ended_at : Time?`
   - `name : String`
   - `scopes : Array(String)`
   - `started_at : Time`
   - `status : BearerLogin::Status`
   - `token_digest : String`
   
   ...and sets up a one-to-many association with the `User` model.

   It removes *Lucky*'s default `created_at : Time` and `update_at : Time` columns.

   You may add other columns and associations specific to your application.

1. Set up the query:
   ```crystal
   # ->>> src/queries/bearer_login_query.cr

   class BearerLoginQuery < BearerLogin::BaseQuery
     # ...
   end
   ```

1. Set up the migration:

   ```crystal
   # ->>> db/migrations/XXXXXXXXXXXXXX_create_bearer_logins.cr

   class CreateBearerLogins::VXXXXXXXXXXXXXX < Avram::Migrator::Migration::V1
     def migrate
       create table_for(BearerLogin) do
         # ...
         primary_key id : Int64

         add_belongs_to user : User, on_delete: :cascade

         add name : String
         add scopes : Array(String)

         add token_digest : String
         add status : String
         add started_at : Time
         add ended_at : Time?
         # ...
       end
     end

     def rollback
       drop table_for(BearerLogin)
     end
   end
   ```

   Add any columns you added to the model here.

1. Set up operations:

   ```crystal
   # ->>> src/operations/create_bearer_login.cr

   class CreateBearerLogin < BearerLogin::SaveOperation
     # ...
     include Shield::CreateBearerLogin
     # ...
   end
   ```

   `Shield::CreateBearerLogin` receives `name : String` and `scopes : Array(String)` parameters, and creates a database entry with a unique ID and hashed token.

   ---
   ```crystal
   # ->>> src/operations/revoke_bearer_login.cr

   class RevokeBearerLogin < BearerLogin::SaveOperation
     # ...
     include Shield::RevokeBearerLogin
     # ...
   end
   ```

   `Shield::RevokeBearerLogin` updates the relevant columns in the database to mark a given *bearer login* as inactive.

1. Set up actions:

   ```crystal
   # ->>> src/actions/bearer_logins/new.cr

   class BearerLogins::New < BrowserAction
     # ...
     include Shield::BearerLogins::New

     get "/bearer-logins/new" do
       html NewPage
     end
     # ...
   end
   ```

   You may need to add `BearerLogins::NewPage` in `src/pages/bearer_logins/new_page.cr`, containing your *bearer login* form.

   The form should be `POST`ed to `BearerLogins::Create`, with the following parameters:

   - `name : String`
   - `scopes : Array(String)`

   ---
   ```crystal
   # ->>> src/actions/bearer_logins/create.cr

   class BearerLogins::Create < BrowserAction
     # ...
     include Shield::BearerLogins::Create

     post "/bearer-logins" do
       run_operation
     end

     # What to do if `run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, bearer_login)
     #  flash.success = "Bearer login created successfully"
     #  flash.info = "Copy the token now; it will only be shown once!"
     #  html ShowPage, operation: operation, bearer_login: bearer_login
     #end

     # What to do if `run_operation` fails
     #
     #def do_run_operation_failed(operation)
     #  flash.failure = "Could not create bearer login"
     #  html NewPage, operation: operation
     #end
     # ...
   end
   ```

   You may need to add `BearerLogins::ShowPage` in `src/pages/bearer_logins/show_page.cr`, that displays the generated login token.

   You display the token by calling `BearerLoginHelper.token(bearer_login, operation)`. This method prepends the *bearer login* ID to the raw token generated in the `CreateBearerLogin` operation, separated by a `.`.
   
   The resulting string is the final token expected to be used by clients to authenticate against the API.

   ---
   ```crystal
   # ->>> src/actions/bearer_logins/index.cr

   class BearerLogins::Index < BrowserAction
     # ...
     include Shield::BearerLogins::Index

     param page : Int32 = 1

     get "/bearer-logins" do
       pages, bearer_logins = paginate(
         BearerLoginQuery.new
           .user_id(user.id)
           .status(BearerLogins:Status.new :started)
       )
    
       html IndexPage, bearer_logins: bearer_logins, pages: pages
     end
     # ...
   end
   ```

   You may need to add `BearerLogins::IndexPage` in `src/pages/bearer_logins/index_page.cr`, that displays all of the current user's active tokens, ideally with buttons to revoke them.

   ---
   ```crystal
   # ->>> src/actions/bearer_logins/destroy.cr

   class BearerLogins::Destroy < BrowserAction
     # ...
     include Shield::BearerLogins::Destroy

     delete "/bearer-logins/:bearer_login_id" do
       run_operation
     end

     # What to do if `run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, login)
     #  flash.keep.success = "Bearer login revoked successfully"
     #  redirect to: Index
     #end

     # What to do if `run_operation` fails
     #
     #def do_run_operation_failed(operation)
     #  flash.keep.failure = "Could not revoke bearer login"
     #  redirect_back fallback: Index
     #end
     # ...
   end
   ```

   `Shield::BearerLogins::Destroy` is responsible for revoking bearer logins. Revoke buttons/links must point to this action.

1. Set up helpers:

   ```crystal
   # ->>> src/helpers/bearer_login_helper.cr

   module BearerLoginHelper
    extend Shield::BearerLoginHelper
   end
   ```

1. Set up utilities:

   ```crystal
   # ->>> src/utilities/bearer_login_headers.cr

   class BearerLoginHeaders # or `struct ...`
     include Shield::BearerLoginHeaders
   end
   ```

   `Shield::BearerLoginHeaders` handles verification of *bearer login* tokens retrieved from request headers.

   ---
   ```crystal
   # ->>> src/utilities/login_headers.cr

   class LoginHeaders # or `struct ...`
     include Shield::LoginHeaders
   end
   ```

   `Shield::LoginHeaders` handles verifications for regular password logins, since APIs do not use sessions for password authentication.

### Action helpers

`Shield::BearerAuthenticationHelpers` adds in the following helpers, as counterparts to those provided in `Shield::AuthenticationHelpers`.

- `#bearer_logged_in?`
- `#bearer_logged_out?`
- `#current_bearer_login`
- `#current_bearer_login!`
- `#current_bearer_user`
- `#current_bearer_user!`

Other helpers are provided as follows:

- `#current_or_bearer_user`:

   Returns `#current_user` if available, otherwise returns `#current_bearer_user`. This is useful for dealing with the current user in APIs.

### Authentication actions via API endpoints

*Shield* allows all authentication actions that are possible via the web browser to be done via API, if the application chooses to expose those endpoints.

For instance, an application may allow a user to register or log in or start a password reset, from API endpoints exposed for such purposes.

*Shield* even supports creating bearer logins from APIs. A user may log in with a regular password via API, and use the token they receive to create bearer logins. They could even create a bearer login via the browser, assigning it `scopes` that allow it to create other bearer logins via API.

For these purposes, *Shield* provides the following modules:

#### Actions

- `Shield::Api::BearerLogins::Create`
- `Shield::Api::BearerLogins::Destroy`
- `Shield::Api::BearerLogins::Index`

- `Shield::Api::CurrentLogin::Create`
- `Shield::Api::CurrentLogin::Destroy`

- `Shield::Api::CurrentUser::Create`
- `Shield::Api::CurrentUser::Show`
- `Shield::Api::CurrentUser::Update`

- `Shield::Api::EmailConfirmationCurrentUser::Create`
- `Shield::Api::EmailConfirmationCurrentUser::Show`
- `Shield::Api::EmailConfirmationCurrentUser::Update`

- `Shield::Api::EmailConfirmations::Create`
- `Shield::Api::EmailConfirmations::Update`

- `Shield::Api::PasswordResets::Create`
- `Shield::Api::PasswordResets::Update`

#### Utilities

- `Shield::EmailConfirmationParams`
- `Shield::PasswordResetParams`

If your application decides to allow any of these functionalities via its API, the modules above should be `include`d in their respective API classes.

### Rate limiting

*Shield* has no API rate limiting implementation yet. For now, applications may achieve this via a reverse proxy (eg *Nginx*), or *Crystal* shards (eg [Defense](https://github.com/defense-cr/defense)).

### API security tips

- Always use HTTPS
- Only expose endpoints you absolutely need.
