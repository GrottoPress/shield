## OAuth 2.0

*Shield* includes tools for building your own OAuth 2.0 authorization server, per [RFC 6749](https://www.rfc-editor.org/rfc/rfc6749.html). The following grant types are supported:

- Authorization Code Grant + PKCE
- Client Credentials Grant

The following grant types will **not** be supported:

- Implicit Grant
- Resource Owner Password Credentials Grant

The following RFCs are implemented:

- [The OAuth 2.0 Authorization Framework](https://www.rfc-editor.org/rfc/rfc6749.html)
- [The OAuth 2.0 Authorization Framework: Bearer Token Usage](https://datatracker.ietf.org/doc/html/rfc6750)
- [OAuth 2.0 Token Revocation](https://datatracker.ietf.org/doc/html/rfc7009)
- [OAuth 2.0 Token Introspection](https://datatracker.ietf.org/doc/html/rfc7662)
- [Proof Key for Code Exchange by OAuth Public Clients](https://datatracker.ietf.org/doc/html/rfc7636)

PKCE is required for public clients using the Authorization Code Grant flow.

### Setting up

1. Configure:

   ```crystal
   # ->>> config/shield.cr

   Shield.configure do |settings|
     # ...
     # What scopes can be assigned to access tokens?
     settings.oauth_access_token_scopes_allowed = ["api.current_user.show"]

     # How long should access tokens last before expiring?
     #settings.oauth_access_token_expiry = 90.days # Set to `nil` to disable

     # How long should authorization codes last before expiring?
     #settings.oauth_authorization_code_expiry = 1.minute

     # A regex of client names to disallow
     #settings.oauth_client_name_filter = /^grotto.*$/i

     # Allowed code challenge methods
     # Valid values: "plain", "S256"
     #settings.oauth_code_challenge_methods_allowed = ["S256"]
     # ...
   end
   ```

1. Set up models:

   ```crystal
   # ->>> src/models/oauth_client.cr

   class OauthClient < BaseModel
     # ...
     include Shield::OauthClient
     include Shield::HasManyOauthAuthorizations

     skip_default_columns
     primary_key id : UUID

     table :oauth_clients do
       # You may add more columns here
     end
     # ...
   end
   ```

   `Shield::OauthClient` adds the following columns:

   - `active_at : Time`
   - `inactive_at : Time?`
   - `name : String`
   - `redirect_uri : String`
   - `secret_digest : String?`
   - `user_id`

   You may add other columns and associations specific to your application.

   ---
   ```crystal
   # ->>> src/models/oauth_authorization.cr

   class OauthAuthorization < BaseModel
     # ...
     include Shield::OauthAuthorization

     skip_default_columns # optional

     table :oauth_authorizations do
       # You may add more columns here
     end
     # ...
   end
   ```

   `Shield::OauthAuthorization` adds the following columns:

   - `active_at : Time`
   - `code_digest : String`
   - `inactive_at : Time?`
   - `oauth_client_id`
   - `pkce : OauthAuthorizationPkce?` (JSON)
   - `scopes : Array(String)`
   - `success : Bool`
   - `user_id`

   You may add other columns and associations specific to your application.

   ---
   ```crystal
   # ->>> src/models/user.cr

   class User < BaseModel
     # ...
     include Shield::HasManyOauthClients
     include Shield::HasManyOauthAuthorizations
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/models/bearer_login.cr

   class BearerLogin < BaseModel
     # ...
     include Shield::OptionalBelongsToOauthClient
     # ...
   end
   ```

   An access token is simply a *bearer login* with its `oauth_client_id` set, so many of the concepts explained in section *10-BEARER-LOGIN.md* applies.

   ---
   ```crystal
   # ->>> src/models/user_settings.cr

   struct UserSettings
     # ...
     include Shield::OauthClientUserSettings
     # ...
   end
   ```

   `Shield::OauthClientUserSettings` adds the following properties:

   - `oauth_access_token_notify : Bool`

   ---
   \* *Skip this if using `UserSettings`* \*

   ```crystal
   # ->>> src/models/user_options.cr

   class UserOptions < BaseModel
     # ...
     include Shield::OauthClientUserOptionsColumns
     # ...
   end
   ```

   `Shield::OauthClientOptionsColumns` adds the following columns:

   - `oauth_access_token_notify : Bool`

1. Set up migrations:

   ```crystal
   # ->>> db/migrations/XXXXXXXXXXXXXX_create_oauth_clients.cr

   class CreateOauthClients::VXXXXXXXXXXXXXX < Avram::Migrator::Migration::V1
     def migrate
       create :oauth_clients do
         # ...
         primary_key id : UUID

         add_belongs_to user : User, on_delete: :cascade

         add active_at : Time
         add inactive_at : Time?
         add name : String
         add redirect_uri : String
         add secret_digest : String?
         # ...
       end
     end

     def rollback
       drop :oauth_clients
     end
   end
   ```

   Add any columns you added to the model here.

   ---
   \* *Skip this if using `UserSettings`* \*

   ```crystal
   # ->>> db/migrations/XXXXXXXXXXXXXX_add_oauth_client_user_options.cr

   class AddOauthClientUserOptions::VXXXXXXXXXXXXXX < Avram::Migrator::Migration::V1
     def migrate
       alter :user_options do
         add oauth_access_token_notify : Bool, fill_existing_with: true
       end
     end

     def rollback
       alter :user_options do
         remove :oauth_access_token_notify
       end
     end
   end
   ```

   ---
   ```crystal
   # ->>> db/migrations/XXXXXXXXXXXXXX_add_bearer_logins_oauth_client_id.cr

   class AddBearerLoginsOauthClientId::VXXXXXXXXXXXXXX < Avram::Migrator::Migration::V1
     def migrate
       alter :bearer_logins do
         add_belongs_to oauth_client : OauthClient?,
           on_delete: :cascade,
           foreign_key_type: UUID
       end
     end

     def rollback
       alter :bearer_logins do
         remove_belongs_to :oauth_client
       end
     end
   end
   ```

   ---
   ```crystal
   # ->>> db/migrations/XXXXXXXXXXXXXX_create_oauth_authorizations.cr

   class CreateOauthAuthorizations::VXXXXXXXXXXXXXX < Avram::Migrator::Migration::V1
     def migrate
       create :oauth_authorizations do
         # ...
         primary_key id : Int64

         add_belongs_to oauth_client : OauthClient,
           on_delete: :cascade,
           foreign_key_type: UUID

         add_belongs_to user : User, on_delete: :cascade

         add active_at : Time
         add code_digest : String
         add inactive_at : Time?
         add pkce : JSON::Any?
         add scopes : Array(String)
         add success : Bool
         # ...
       end
     end

     def rollback
       drop :oauth_authorizations
     end
   end
   ```

   Add any columns you added to the model here.

1. Set up operations:

   All operations are already set up. You may reopen an operation to add new functionality.

   ```crystal
   # ->>> src/operations/create_oauth_client.cr

   class RegisterOauthClient < OauthClient::SaveOperation
     # ...
   end
   ```

   `RegisterOauthClient` receives `name : String`, `public : Bool` and `redirect_uri : String` parameters, and creates a database entry with a unique ID and an optional hashed secret for *confidential* clients.

   ---
   ```crystal
   # ->>> src/operations/rotate_oauth_client_secret.cr

   class RotateOauthClientSecret < OauthClient::SaveOperation
     # ...
   end
   ```

   `RotateOauthClientSecret` updates a client's secret to a new one, rendering the old secret invalid.

   ---
   ```crystal
   # ->>> src/operations/deactivate_oauth_client.cr

   class DeactivateOauthClient < OauthClient::SaveOperation
     # ...
     # By default, *Shield* marks all authorizations as inactive,
     # after a client is deactivated, without deleting them.
     #
     # Enable this to delete them from the database instead.
     #include Shield::DeleteOauthAuthAuthorizationsAfterDeactivateOauthClient

     # By default, *Shield* marks all access tokens as inactive,
     # after a client is deactivated, without deleting them.
     #
     # Enable this to delete them from the database instead.
     #include Shield::DeleteAccessTokensAfterDeactivateOauthClient
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/operations/delete_oauth_client.cr

   class DeleteOauthClient < OauthClient::DeleteOperation
     # ...
   end
   ```

   `DeleteOauthClient` actually deletes a given *client* from the database. Use this instead of `DeactivateOauthClient` if you intend to actually delete clients.

   ---
   ```crystal
   # ->>> src/operations/update_oauth_client.cr

   class UpdateOauthClient < OauthClient::SaveOperation
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/operations/revoke_oauth_permission.cr

   class RevokeOauthPermission < User::SaveOperation
     # ...
     # By default, *Shield* marks all authorizations as inactive,
     # after permission is revoked, without deleting them.
     #
     # Enable this to delete them from the database instead.
     #include Shield::DeleteOauthAuthorizationAfterRevokeOauthPermission
     # ...
   end
   ```

   This revokes all access tokens issued to a given client for a particular user, effectively revoking all permissions granted the client by the user. Conversely, a developer may revoke a user's access to their client.

   ---
   ```crystal
   # ->>> src/operations/delete_oauth_permission.cr

   class DeleteOauthPermission < User::SaveOperation
     # ...
     # By default, *Shield* deletes all authorizations from the database,
     # after permission is deleted.
     #
     # Enable this to mark them as inactive instead, without deleting them
     # from the database.
     #include Shield::RevokeOauthAuthorizationAfterDeleteOauthPermission
     # ...
   end
   ```

   This actually deletes the access tokens from the database, rather than mark them as inactive. Use this instead of `RevokeOauthPermission` if you intend to actually delete access tokens.

   ---
   ```crystal
   # ->>> src/operations/start_oauth_authorization.cr

   class StartOauthAuthorization < OauthAuthorization::SaveOperation
     # ...
   end
   ```

   `StartOauthAuthorization` creates a database entry with a unique ID and a hashed *code* for use by clients to obtain an access token. It expects the following parameters:

   - `granted : Bool`
   - `code_challenge : String`
   - `code_challenge_method : String`
   - `oauth_client_id` or `oauth_client : OauthClient`
   - `redirect_uri : String`
   - `response_type : String`
   - `state : String`
   - `user_id` or `user : User`

   ---
   ```crystal
   # ->>> src/operations/end_oauth_authorization.cr

   class EndOauthAuthorization < OauthAuthorization::SaveOperation
     # ...
   end
   ```

   `EndOauthAuthorization` marks an authorization as inactive, to ensure it is never reused.

   ---
   ```crystal
   # ->>> src/operations/delete_oauth_authorization.cr

   class DeleteOauthAuthorization < OauthAuthorization::DeleteOperation
     # ...
   end
   ```

   `DeleteOauthAuthorization` is an alternative to `EndOauthAuthorization` that actually deletes the record from the database.

   ---
   ```crystal
   # ->>> src/operations/create_oauth_access_token.cr

   class CreateOauthAccessTokenFromAuthorization < BearerLogin::SaveOperation
     # ...
     # By default, *Shield* revokes access tokens if an authorization code
     # is presented more than once.
     #
     # Enable this to delete them from the database instead.
     #include Shield::DeleteAccessTokensIfOauthAuthorizationReplayed
     # ...
   end
   ```

   This operation creates an access token from a given authorization.

1. Set up actions:

   ```crystal
   # ->>> src/actions/current_user/oauth_clients/new.cr

   class CurrentUser::OauthClients::New < BrowserAction
     # ...
     include Shield::CurrentUser::OauthClients::New

     get "/account/oauth/clients/new" do
       operation = RegisterOauthClient.new(user: user)
       html NewPage, operation: operation
     end
     # ...
   end
   ```

   You may need to add `CurrentUser::OauthClients::NewPage` in `src/pages/current_user/oauth_cliets/new_page.cr`, containing your new client form.

   The form should be `POST`ed to `CurrentUser::OauthClients::Create`, with the following parameters:

   - `name : String`
   - `public : Bool`
   - `redirect_uri : String`

   ---
   ```crystal
   # ->>> src/actions/current_user/oauth_clients/create.cr

   class CurrentUser::OauthClients::Create < BrowserAction
     # ...
     include Shield::CurrentUser::OauthClients::Create

     post "/account/oauth/clients" do
       run_operation
     end

     #def do_run_operation_succeeded(operation, oauth_client)
     #  flash.success = Rex.t(:"action.current_user.oauth_client.create.success")
     #  redirect to: ::OauthClients::Secret::Show
     #end

     #def do_run_operation_failed(operation)
     #  flash.failure = Rex.t(:"action.current_user.oauth_client.create.failure")
     #  html NewPage, operation: operation
     #end
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/actions/current_user/oauth_clients/destroy.cr

   class OauthClients::Destroy < BrowserAction
     # By default, *Shield* marks the client as inactive,
     # without deleting it.
     #
     # To delete them, use `Shield::OauthClients::Delete` instead.
     include Shield::OauthClients::Destroy

     delete "/oauth/clients/:oauth_client_id" do
       run_operation
     end

     #def do_run_operation_succeeded(operation, oauth_client)
     #  flash.success = Rex.t(:"action.oauth_client.destroy.success")
     #  redirect to: Index
     #end

     #def do_run_operation_failed(operation)
     #  flash.failure = Rex.t(:"action.oauth_client.destroy.failure")
     #  redirect_back fallback: Index
     #end
   end
   ```

   ---
   ```crystal
   # ->>> src/actions/oauth_clients/secret/show.cr

   class OauthClients::Secret::Show < BrowserAction
     # ...
     include Shield::OauthClients::Secret::Show

     get "/oauth/clients/secret" do
       html ShowPage, oauth_client: oauth_client?, secret: secret?
     end
     # ...
   end
   ```

   You may need to add `OauthClients::Secret::ShowPage` in `src/pages/oauth_cliets/secret/show_page.cr`, that displays the client secret.

   After the client is created, the secret is saved in session and retrieved for display in this action. You should let the user know the secret cannot be recovered if lost.

   ---
   ```crystal
   # ->>> src/actions/oauth_clients/secret/update.cr

   class OauthClients::Secret::Update < BrowserAction
     # ...
     include Shield::OauthClients::Secret::Update

     patch "/oauth/clients/:oauth_client_id/secret" do
       run_operation
     end

     #def do_run_operation_succeeded(operation, oauth_client)
     #  flash.success = Rex.t(:"action.oauth_client.secret.update.success")
     #  redirect to: Show
     #end

     #def do_run_operation_failed(operation)
     #  flash.failure = Rex.t(:"action.oauth_client.secret.update.failure")
     #
     #  redirect_back fallback: OauthClients::Show.with(
     #    oauth_client_id: oauth_client_id
     #  )
     #end
     # ...
   end
   ```

   This action handles refreshing of client secrets. The secret "refresh" button/link should point here.

   ---
   ```crystal
   # ->>> src/actions/current_user/oauth_clients/index.cr

   class CurrentUser::OauthClients::Index < BrowserAction
     # ...
     include Shield::CurrentUser::OauthClients::Index

     get "/account/oauth/clients" do
       html IndexPage, oauth_clients: oauth_clients, pages: pages
     end
     # ...
   end
   ```

   You may need to add `CurrentUser::OauthClients::IndexPage` in `src/pages/current_user/oauth_cliets/index_page.cr`, containing the list of clients created by the current user.

   ---
   ```crystal
   # ->>> src/actions/current_user/oauth_permissons/index.cr

   class CurrentUser::OauthPermissions::Index < BrowserAction
     # ...
     include Shield::CurrentUser::OauthPermissions::Index

     get "/account/oauth/permissions" do
       html IndexPage, oauth_clients: oauth_clients, pages: pages
     end
     # ...
   end
   ```

   You may need to add `CurrentUser::OauthPermissions::IndexPage` in `src/pages/current_user/oauth_permissions/index_page.cr`, containing the list of clients the current user has authorized.

   ---
   ```crystal
   # ->>> src/actions/current_user/oauth_permissons/destroy.cr

   class OauthPermissions::Destroy < BrowserAction
     # ...
     # By default, *Shield* marks the access tokens as inactive,
     # without deleting them.
     #
     # To delete them, use `Shield::OauthPermissions::Delete` instead.
     include Shield::OauthPermissions::Destroy

     delete "/oauth/clients/:oauth_client_id/users/:user_id" do
       run_operation
     end

     #def do_run_operation_succeeded(operation, user)
     #  flash.success = Rex.t(:"action.oauth_permission.destroy.success")
     #
     #  redirect to: OauthClients::Users::Index.with(
     #    oauth_client_id: oauth_client_id
     #  )
     #end

     #def do_run_operation_failed(operation)
     #  flash.failure = Rex.t(:"action.oauth_permission.destroy.failure")
     #
     #  redirect_back fallback: OauthClients::Users::Index.with(
     #    oauth_client_id: oauth_client_id
     #  )
     #end
     # ...
   end
   ```

   This action is reponsible for revoking a single client's access to a single user, by revoking all access tokens issued to the client for that user.

   If you would like the current user to revoke all permissions granted to all clients, use the `CurrentUser::OauthAccessTokens::Destroy` action.

   ---
   ```crystal
   # ->>> src/actions/oauth/authorize.cr

   class Oauth::Authorize < BrowserAction
     # ...
     include Shield::Oauth::Authorize

     get "/oauth/authorize" do
       run_operation
     end
     # ...
   end
   ```

   This action represents the authorization endpoint, where the whole OAuth process begins. Direct OAuth clients to this route with the following query parameters:

   - `client_id : String`
   - `code_challenge : String?` (Required for public clients)
   - `code_challenge_method : String?` (Required for public clients)
   - `redirect_uri : String`
   - `response_type : String`
   - `scope : String`
   - `state : String`

   ---
   ```crystal
   # ->>> src/actions/oauth/authorization/new.cr

   class Oauth::Authorization::New < BrowserAction
     # ...
     include Shield::Oauth::Authorization::New
     include Oauth::Authorization::PipeCallbacks

     get "oauth/authorization/new" do
       operation = StartOauthAuthorization.new(
         redirect_uri: redirect_uri.to_s,
         response_type: response_type.to_s,
         code_challenge: code_challenge.to_s,
         code_challenge_method: code_challenge_method,
         state: state.to_s,
         scopes: scopes,
         user: user,
         oauth_client: oauth_client?,
       )

       html NewPage, operation: operation
     end
     # ...
   end
   ```

   You may need to add `Oauth::Authorization::NewPage` in `src/pages/oauth/authorization/new_page.cr`, containing your *authorization* form.

   The form should be `POST`ed to `Oauth::Authorization::Create`, with the following **nested** parameters, preferrably as hidden input fields with allow/deny button(s):

   - `client_id : String`
   - `code_challenge : String?` (Required for public clients)
   - `code_challenge_method : String?` (Required for public clients)
   - `granted : Bool`
   - `redirect_uri : String`
   - `response_type : String`
   - `scope : String`
   - `state : String`

   The page should explain carefully what permissions the client is requesting from the user, to enable the user decide on whether to grant or deny the request.

   See <https://www.oauth.com/oauth2-servers/authorization/the-authorization-interface/>.

   ---
   ```crystal
   # ->>> src/actions/oauth/authorization/create.cr

   class Oauth::Authorization::Create < BrowserAction
     # ...
     include Shield::Oauth::Authorization::Create
     include Oauth::Authorization::PipeCallbacks

     post "/oauth/authorization" do
       run_operation
     end

     #def do_run_operation_succeeded(operation, oauth_authorization)
     #  code = OauthAuthorizationCredentials.new(operation, oauth_authorization)
     #  redirect to: oauth_redirect_uri(code: code.to_s, state: state).to_s
     #end

     #def do_run_operation_failed(operation)
     #  error = operation.granted.value ? "invalid_request" : "access_denied"
     #  redirect to: oauth_redirect_uri(error: error, state: state).to_s
     #end
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/actions/oauth/authorization/pipe_callbacks.cr

   module Oauth::Authorization::PipeCallbacks
     macro included
       #def do_oauth_validate_client_id_failed
       #  json({
       #    error: "invalid_request",
       #    error_description: Rex.t(
       #      :"action.pipe.oauth.client_id_invalid",
       #      client_id: client_id
       #    )
       #  })
       #end

       #def do_oauth_validate_redirect_uri_failed
       #  json({
       #    error: "invalid_request",
       #    error_description: Rex.t(
       #      :"action.pipe.oauth.redirect_uri_invalid",
       #      redirect_uri: redirect_uri
       #    )
       #  })
       #end

       #def do_oauth_check_duplicate_params_failed
       #  redirect to: oauth_redirect_uri(
       #    error: "invalid_request",
       #    error_description: Rex.t(:"action.pipe.oauth.duplicate_params"),
       #    state: state
       #  ).to_s
       #end

       #def do_oauth_validate_scope_failed
       #  redirect to: oauth_redirect_uri(
       #    error: "invalid_scope",
       #    error_description: Rex.t(
       #      :"action.pipe.oauth.scope_invalid",
       #      scope: scope
       #    ),
       #    state: state
       #  ).to_s
       #end

       #def do_oauth_require_authorization_params_failed
       #  redirect to: oauth_redirect_uri(
       #    error: "invalid_request",
       #    error_description: Rex.t(:"action.pipe.oauth.params_missing"),
       #    state: state
       #  ).to_s
       #end

       #def do_oauth_validate_response_type_failed
       #  redirect to: oauth_redirect_uri(
       #    error: "unsupported_response_type",
       #    error_description: Rex.t(
       #      :"action.pipe.oauth.response_type_invalid",
       #      response_type: response_type
       #    ),
       #    state: state
       #  ).to_s
       #end

       #def do_oauth_require_code_challenge_failed
       #  redirect to: oauth_redirect_uri(
       #    error: "invalid_request",
       #    error_description: Rex.t(:"action.pipe.oauth.code_challenge_required"),
       #    state: state
       #  ).to_s
       #end

       #def do_oauth_validate_code_challenge_method_failed
       #  redirect to: oauth_redirect_uri(
       #    error: "invalid_request",
       #    error_description: Rex.t(
       #      :"action.pipe.oauth.code_challenge_method_invalid"
       #    ),
       #    state: state
       #  ).to_s
       #end
     end
   end
   ```

   ---
   ```crystal
   # ->>> src/actions/api/oauth/token/create.cr

   class Api::Oauth::Token::Create < ApiAction
     # ...
     include Shield::Api::Oauth::Token::Create
     include Api::Oauth::Token::PipeCallbacks

     post "/oauth/token" do
       run_operation
     end

     #def do_run_operation_succeeded(operation, bearer_login)
     #  json({
     #    access_token: BearerLoginCredentials.new(operation, bearer_login),
     #    expires_in: bearer_login.status.span?.try(&.total_seconds.to_i64),
     #    scope: bearer_login.scopes.join(' '),
     #    token_type: "Bearer"
     #  })
     #end

     #def do_run_operation_failed(operation)
     #  json({error: "invalid_grant"})
     #end
     # ...
   end
   ```

   This action represents the token endpoint, where the client exchanges the authorization code for an access token. The following body parameters are required:

   - `code : String`
   - `code_verifier : String?`
   - `client_id : String` (Optional if using HTTP basic authentication)
   - `client_secret : String` (Optional if using HTTP basic authentication)
   - `grant_type : String`
   - `redirect_uri : String`

   Code verifier is required for public clients, and for confidential clients if `code_challenge` was set during authorization request. Client secret is not required for public clients.

   ---
   ```crystal
   # ->>> src/actions/api/oauth/token/pipe_callbacks.cr

   module Api::Oauth::Token::PipeCallbacks
     macro included
       # ...
       #def do_oauth_validate_client_id_failed
       #  json({
       #    error: "invalid_client",
       #    error_description: Rex.t(
       #      :"action.pipe.oauth.client_id_invalid",
       #      client_id: client_id
       #    )
       #  })
       #end

       #def do_oauth_validate_redirect_uri_failed
       #  json({
       #    error: "invalid_request",
       #    error_description: Rex.t(
       #      :"action.pipe.oauth.redirect_uri_invalid",
       #      redirect_uri: redirect_uri
       #    )
       #  })
       #end

       #def do_oauth_check_duplicate_params_failed
       #  json({
       #    error: "invalid_request",
       #    error_description: Rex.t(:"action.pipe.oauth.duplicate_params"),
       #  })
       #end

       #def do_oauth_validate_scope_failed
       #  json({
       #    error: "invalid_scope",
       #    error_description: Rex.t(
       #      :"action.pipe.oauth.scope_invalid",
       #      scope: scope
       #    ),
       #  })
       #end

       #def do_oauth_validate_client_secret_failed
       #  json({
       #    error: "invalid_client",
       #    error_description: Rex.t(
       #      :"action.pipe.oauth.client_auth_failed",
       #      client_id: client_id
       #    )
       #  })
       #end

       #def do_oauth_require_access_token_params_failed
       #  json({
       #    error: "invalid_request",
       #    error_description: Rex.t(:"action.pipe.oauth.params_missing")
       #  })
       #end

       #def do_oauth_validate_grant_type_failed
       #  json({
       #    error: "unsupported_grant_type",
       #    error_description: Rex.t(
       #      :"action.pipe.oauth.grant_type_invalid",
       #      grant_type: grant_type
       #    )
       #  })
       #end

       #def do_oauth_validate_code_failed
       #  json({
       #    error: "invalid_grant",
       #    error_description: Rex.t(:"action.pipe.oauth.auth_code_invalid"),
       #  })
       #end

       #def do_oauth_check_multiple_client_auth_failed
       #  json({
       #    error: "invalid_request",
       #    error_description: Rex.t(:"action.pipe.oauth.multiple_client_auth"),
       #  })
       #end
       # ...
     end
   end
   ```

   ---
   ```crystal
   # ->>> src/actions/api/oauth/token/verify.cr

   class Api::Oauth::Token::Verify < ApiAction
     # ...
     include Shield::Api::Oauth::Token::Verify

     post "/oauth/token/verify" do
       run_operation
     end

     #def do_verify_operation_succeeded(utility, bearer_login)
     #  json({
     #    active: true,
     #    client_id: bearer_login.oauth_client_id.to_s,
     #    exp: bearer_login.inactive_at.try(&.to_unix),
     #    iat: bearer_login.active_at.to_unix,
     #    jti: bearer_login.id.to_s,
     #    scope: bearer_login.scopes.join(' '),
     #    sub: bearer_login.user_id.to_s,
     #    token_type: "Bearer",
     #  })
     #end

     #def do_verify_operation_failed(utility)
     #  json({active: false})
     #end
     # ...
   end
   ```

   This action is the token **introspection** endpoint, where a resource server may check with the authorization server for the validity of a token. The following body parameters are expected:

   - `scope : String?`
   - `token : String`

   If `scope` parameter is provided, the action will further check that the access token's scopes include the given scope.
   
   The action requires the requester to be logged in. Typically, this should be done by creating an API token (See *10-BEARER-LOGIN.md*) with the needed scope to access the introspection endpoint. This token is sent in the `Authorization` header during the request.

   Alternatively, resource servers may register as confidential clients and present their `client_id` and `client_secret` (or use HTTP basic authentication), instead of a bearer token.

   ---
   ```crystal
   # ->>> src/actions/api/oauth/token/destroy.cr

   class Api::Oauth::Token::Destroy < ApiAction
     # ...
     # By default, *Shield* marks the access tokens as inactive,
     # without deleting them.
     #
     # To delete them, use `Shield::Api::Oauth::Token::Delete` instead.
     include Shield::Api::Oauth::Token::Destroy

     post "/oauth/token/revoke" do
       run_operation
     end

     #def do_run_operation_succeeded(operation, token)
     #  json({success: true})
     #end

     #def do_run_operation_failed(operation)
     #  json({error: operation.client_authorized? ?
     #    "invalid_request" :
     #    "unauthorized_client"})
     #end
     # ...
   end
   ```

   `Shield::Api::Oauth::Token::Destroy` is the token **revocation** endpoint, where a client may request the authorization server to revoke a token. The following body parameters are expected:

   - `client_id : String` (Optional if using HTTP basic authentication)
   - `client_secret : String` (Optional if using HTTP basic authentication)
   - `token : String`

   This action will check that the token was issued to the same client requesting the revocation, before processing the request.

   The action requires confidential clients to authenticate, the same way as for the token endpoint. Public clients should send only the client ID along with the request.

   In addition to revoking the token, all other access tokens issued to the same client for the same user are revoked.

### References:

- [OAuth 2.0 Threat Model and Security Considerations](https://datatracker.ietf.org/doc/html/rfc6819)
- [OAuth.com](https://www.oauth.com)
