module Shield::Api::OauthAccessTokens::Create
  macro included
    include Shield::Api::OauthAccessTokenPipes

    skip :require_logged_in
    skip :require_logged_out
    skip :check_authorization

    before :oauth_validate_client_id
    # before :oauth_handle_errors
    before :oauth_check_duplicate_params
    before :oauth_require_access_token_params
    before :oauth_validate_redirect_uri
    before :oauth_validate_grant_type
    before :oauth_validate_code
    before :oauth_check_multiple_client_auth
    before :oauth_validate_client_secret

    # post "/oauth/tokens" do
    #   run_operation
    # end

    def run_operation
      CreateOauthAccessToken.create(
        oauth_authorization: oauth_authorization?
      ) do |operation, bearer_login|
        if operation.saved?
          do_run_operation_succeeded(operation, bearer_login.not_nil!)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, bearer_login)
      json({
        access_token: operation.token,
        token_type: "Bearer",
        expires_in: bearer_login.status.span?.try(&.total_seconds.to_i64),
        scope: bearer_login.scopes.join(' '),
        user_id: bearer_login.user_id
      })
    end

    def do_run_operation_failed(operation)
      json({
        error: "invalid_grant",
        error_description: Rex.t(:"action.pipe.oauth.auth_code_invalid"),
      })
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
  end
end
