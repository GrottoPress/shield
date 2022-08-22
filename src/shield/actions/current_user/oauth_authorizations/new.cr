module Shield::CurrentUser::OauthAuthorizations::New
  macro included
    include Shield::OauthAuthorizationPipes

    skip :require_logged_out

    before :oauth_validate_client_id
    # before :oauth_handle_errors
    before :oauth_check_duplicate_params
    before :oauth_require_authorization_params
    before :oauth_validate_response_type
    before :oauth_validate_redirect_uri
    before :oauth_validate_scope
    before :oauth_require_code_challenge
    before :oauth_validate_code_challenge_method

    param client_id : String?
    param code_challenge : String?
    param code_challenge_method : String = "plain"
    param redirect_uri : String?
    param response_type : String?
    param scope : String?

    # get "/account/oauth/authorizations/new" do
    #   operation = StartOauthAuthorization.new(
    #     redirect_uri: redirect_uri.to_s,
    #     response_type: response_type.to_s,
    #     code_challenge: code_challenge.to_s,
    #     code_challenge_method: code_challenge_method,
    #     state: state.to_s,
    #     scopes: scopes,
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
      OauthAuthorizationStateSession.new(session).state?
    end

    def scopes : Array(String)
      scope.try(&.split) || Array(String).new
    end

    def authorize?(user : Shield::User) : Bool
      user.id == self.user.id
    end
  end
end
