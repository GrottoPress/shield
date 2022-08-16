# Implements the OAuth 2.0 authorization framework as defined
# in [RFC 6749](https://datatracker.ietf.org/doc/html/rfc6749)
module Shield::Api::OauthAuthorizationPipes
  macro included
    include Shield::OauthAuthorizationPipes
    include Shield::Api::OauthPipes

    def do_oauth_require_params_failed
      json({
        error: "invalid_request",
        error_description: Rex.t(:"action.pipe.oauth.params_missing"),
        redirect_to: oauth_redirect_uri(
          error: "invalid_request",
          error_description: Rex.t(:"action.pipe.oauth.params_missing"),
          state: state
        ).to_s,
        state: state
      })
    end

    def do_oauth_validate_response_type_failed
      json({
        error: "unsupported_response_type",
        error_description: Rex.t(
          :"action.pipe.oauth.response_type_invalid",
          response_type: response_type
        ),
        redirect_to: oauth_redirect_uri(
          error: "unsupported_response_type",
          error_description: Rex.t(
            :"action.pipe.oauth.response_type_invalid",
            response_type: response_type
          ),
          state: state
        ).to_s,
        state: state
      })
    end

    def do_oauth_require_code_challenge_failed
      json({
        error: "invalid_request",
        error_description: Rex.t(:"action.pipe.oauth.code_challenge_required"),
        redirect_to: oauth_redirect_uri(
          error: "invalid_request",
          error_description: Rex.t(
            :"action.pipe.oauth.code_challenge_required"
          ),
          state: state
        ).to_s,
        state: state
      })
    end

    def do_oauth_validate_code_challenge_method_failed
      json({
        error: "invalid_request",
        error_description: Rex.t(
          :"action.pipe.oauth.code_challenge_method_invalid"
        ),
        redirect_to: oauth_redirect_uri(
          error: "invalid_request",
          error_description: Rex.t(
            :"action.pipe.oauth.code_challenge_method_invalid"
          ),
          state: state
        ).to_s,
        state: state
      })
    end
  end
end
