# Implements the OAuth 2.0 authorization framework as defined
# in [RFC 6749](https://datatracker.ietf.org/doc/html/rfc6749)
module Shield::OauthAuthorizationPipes
  macro included
    include Shield::OauthPipes

    def oauth_require_params
      if response_type && !scopes.empty? && state
        continue
      else
        response.status_code = 400
        do_oauth_require_params_failed
      end
    end

    def oauth_validate_response_type
      if response_type == "code"
        continue
      else
        response.status_code = 400
        do_oauth_validate_response_type_failed
      end
    end

    def oauth_require_code_challenge
      if code_challenge || !oauth_client? || oauth_client.confidential?
        continue
      else
        response.status_code = 400
        do_oauth_require_code_challenge_failed
      end
    end

    def oauth_validate_code_challenge_method
      allowed_methods = Shield.settings.oauth_code_challenge_methods_allowed

      if code_challenge_method.in?(allowed_methods)
        continue
      else
        response.status_code = 400
        do_oauth_validate_code_challenge_method_failed
      end
    end

    def do_oauth_require_params_failed
      redirect to: oauth_redirect_uri(
        error: "invalid_request",
        error_description: Rex.t(:"action.pipe.oauth.params_missing"),
        state: state
      ).to_s
    end

    def do_oauth_validate_response_type_failed
      redirect to: oauth_redirect_uri(
        error: "unsupported_response_type",
        error_description: Rex.t(
          :"action.pipe.oauth.response_type_invalid",
          response_type: response_type
        ),
        state: state
      ).to_s
    end

    def do_oauth_require_code_challenge_failed
      redirect to: oauth_redirect_uri(
        error: "invalid_request",
        error_description: Rex.t(:"action.pipe.oauth.code_challenge_required"),
        state: state
      ).to_s
    end

    def do_oauth_validate_code_challenge_method_failed
      redirect to: oauth_redirect_uri(
        error: "invalid_request",
        error_description: Rex.t(
          :"action.pipe.oauth.code_challenge_method_invalid"
        ),
        state: state
      ).to_s
    end
  end
end
