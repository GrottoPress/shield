module Shield::Oauth::Authorization::New
  macro included
    include Shield::Oauth::Authorization::Pipes

    before :oauth_validate_client_id
    # before :oauth_handle_errors
    before :oauth_check_duplicate_params
    before :oauth_require_authorization_params
    before :oauth_validate_response_type
    before :oauth_validate_redirect_uri
    before :oauth_validate_scope
    before :oauth_require_code_challenge
    before :oauth_validate_code_challenge_method
    before :oauth_require_logged_in

    param client_id : String?
    param code_challenge : String?
    param code_challenge_method : String = OauthGrantPkce::METHOD_PLAIN
    param redirect_uri : String?
    param response_type : String?
    param scope : String?

    # get "/oauth/authorization" do
    #   operation = StartOauthGrant.new(
    #     redirect_uri: redirect_uri.to_s,
    #     response_type: response_type.to_s,
    #     code_challenge: code_challenge.to_s,
    #     code_challenge_method: code_challenge_method,
    #     state: state.to_s,
    #     scopes: scopes,
    #     type: OauthGrantType.authorization_code,
    #     user: user,
    #     oauth_client: oauth_client?,
    #   )
    #
    #   html NewPage, operation: operation
    # end

    def user
      current_user
    end

    getter state : String? do
      OauthStateSession.new(session).state?(delete: true)
    end

    def scopes : Array(String)
      scope.try(&.split) || Array(String).new
    end
  end
end
