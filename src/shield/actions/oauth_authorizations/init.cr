module Shield::OauthAuthorizations::Init
  # IMPORTANT!
  #
  # Ensure tokens are not leaked in HTTP Referer header
  #
  # REFERENCES:
  #
  # - https://developer.mozilla.org/en-US/docs/Web/Security/Referer_header:_privacy_and_security_concerns
  # - https://twitter.com/HusseiN98D/status/1254888748216655872
  # - https://github.com/thoughtbot/clearance/pull/707
  macro included
    include Shield::OauthAuthorizationPipes

    param client_id : String?
    param code_challenge : String?
    param code_challenge_method : String?
    param redirect_uri : String?
    param response_type : String?
    param scope : String?
    param state : String?

    # get "/oauth/authorize" do
    #   run_operation
    # end

    def run_operation
      state.try do |_state|
        OauthAuthorizationStateSession.new(session).set(_state)
      end

      redirect to: CurrentUser::OauthAuthorizations::New.with( # <= IMPORTANT!
        client_id: client_id,
        code_challenge: code_challenge,
        code_challenge_method: code_challenge_method,
        redirect_uri: redirect_uri,
        response_type: response_type,
        scope: scope,
      )
    end
  end
end
