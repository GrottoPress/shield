# The Token endpoint
#
module Shield::Api::Oauth::Token::Create
  macro included
    include Shield::Api::Oauth::Token::Pipes

    before :oauth_validate_client_id
    # before :oauth_handle_errors
    before :oauth_check_duplicate_params
    before :oauth_require_access_token_params
    before :oauth_validate_grant_type
    before :oauth_validate_redirect_uri
    before :oauth_validate_scope
    before :oauth_validate_code
    before :oauth_validate_refresh_token
    before :oauth_validate_code_verifier
    before :oauth_check_multiple_client_auth
    before :oauth_require_confidential_client
    before :oauth_validate_client_secret

    # post "/oauth/token" do
    #   run_operation
    # end

    def run_operation
      case oauth_grant_type
      when .client_credentials?
        run_client_credentials_grant_operation
      when .refresh_token?
        run_refresh_token_grant_operation
      else
        run_authorization_code_grant_operation
      end
    end

    def do_run_operation_succeeded(operation, bearer_login)
      json({
        access_token: BearerLoginCredentials.new(operation, bearer_login),
        expires_in: bearer_login.status.span?.try(&.total_seconds.to_i64),
        refresh_token: operation.credentials.try(&.to_s),
        scope: bearer_login.scopes.join(' '),
        token_type: "Bearer"
      })
    end

    def do_run_operation_failed(operation)
      json({error: "invalid_grant"})
    end

    def grant_type : String?
      params.get?(:grant_type)
    end

    def code : String?
      params.get?(:code)
    end

    def redirect_uri : String?
      params.get?(:redirect_uri)
    end

    def code_verifier : String?
      params.get?(:code_verifier)
    end

    def refresh_token : String?
      params.get?(:refresh_token)
    end

    def client_id : String?
      OauthClientCredentials.from_headers?(request).try(&.id.to_s) ||
        params.get?(:client_id)
    end

    def client_secret : String?
      if OauthClientCredentials.from_headers?(request).try(&.id)
        OauthClientCredentials.from_headers?(request).try(&.password)
      else
        params.get?(:client_secret)
      end
    end

    def scope : String?
      params.get?(:scope)
    end

    def scopes : Array(String)
      scope.try(&.split) || Array(String).new
    end

    private def run_client_credentials_grant_operation
      CreateOauthAccessTokenFromClient.create(
        oauth_client: oauth_client,
        scopes: scopes
      ) do |operation, bearer_login|
        if operation.saved?
          do_run_operation_succeeded(operation, bearer_login.not_nil!)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    private def run_refresh_token_grant_operation
      CreateOauthAccessTokenFromGrant.create(
        oauth_grant: oauth_grant,
        scopes: scopes
      ) do |operation, bearer_login|
        if operation.saved?
          do_run_operation_succeeded(operation, bearer_login.not_nil!)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    private def run_authorization_code_grant_operation
      CreateOauthAccessTokenFromGrant.create(
        oauth_grant: oauth_grant
      ) do |operation, bearer_login|
        if operation.saved?
          do_run_operation_succeeded(operation, bearer_login.not_nil!)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end
  end
end
