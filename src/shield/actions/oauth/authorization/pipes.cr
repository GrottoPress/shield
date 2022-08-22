# Implements the OAuth 2.0 authorization framework as defined
# in [RFC 6749](https://datatracker.ietf.org/doc/html/rfc6749)
module Shield::Oauth::Authorization::Pipes
  macro included
    include Shield::Oauth::Pipes

    def oauth_require_authorization_params
      if response_type && !scopes.empty? && state
        continue
      else
        response.status_code = 400
        do_oauth_require_authorization_params_failed
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

    def do_oauth_validate_client_id_failed
      json({
        error: "invalid_request",
        error_description: Rex.t(
          :"action.pipe.oauth.client_id_invalid",
          client_id: client_id
        )
      })
    end

    def do_oauth_validate_redirect_uri_failed
      json({
        error: "invalid_request",
        error_description: Rex.t(
          :"action.pipe.oauth.redirect_uri_invalid",
          redirect_uri: redirect_uri
        )
      })
    end

    def do_oauth_check_duplicate_params_failed
      redirect to: oauth_redirect_uri(
        error: "invalid_request",
        error_description: Rex.t(:"action.pipe.oauth.duplicate_params"),
        state: state
      ).to_s
    end

    def do_oauth_validate_scope_failed
      redirect to: oauth_redirect_uri(
        error: "invalid_scope",
        error_description: Rex.t(
          :"action.pipe.oauth.scope_invalid",
          scope: scope
        ),
        state: state
      ).to_s
    end

    def do_oauth_handle_errors(error)
      redirect to: oauth_redirect_uri(
        error: "server_error",
        error_description: Rex.t(
          :"action.pipe.oauth.server_error",
          message: error.message
        ),
        state: state
      ).to_s
    end

    def do_oauth_require_authorization_params_failed
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
