# The Authorization endpoint
#
module Shield::Oauth::Authorize
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
    include Shield::Oauth::Authorization::Pipes

    param client_id : String? = nil
    param code_challenge : String? = nil
    param code_challenge_method : String? = nil
    param redirect_uri : String? = nil
    param response_type : String? = nil
    param scope : String? = nil
    param state : String? = nil

    # get "/oauth/authorize" do
    #   run_operation
    # end

    def run_operation
      state.try { |_state| OauthStateSession.new(session).set(_state) }

      redirect to: Oauth::Authorization::New.with( # <= IMPORTANT!
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
