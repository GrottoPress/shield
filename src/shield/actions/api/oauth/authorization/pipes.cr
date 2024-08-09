# Implements the OAuth 2.0 authorization framework as defined
# in [RFC 6749](https://datatracker.ietf.org/doc/html/rfc6749)
module Shield::Api::Oauth::Authorization::Pipes
  macro included
    include Shield::Oauth::Authorization::Pipes

    def do_oauth_check_duplicate_params_failed
      json({
        error: "invalid_request",
        error_description: Rex.t(:"action.pipe.oauth.duplicate_params"),
        redirect_to: oauth_redirect_uri(
          error: "invalid_request",
          error_description: Rex.t(:"action.pipe.oauth.duplicate_params"),
          state: state
        ).to_s,
        state: state
      })
    end

    def do_oauth_validate_scope_failed
      json({
        error: "invalid_scope",
        error_description: Rex.t(
          :"action.pipe.oauth.scope_invalid",
          scope: scope
        ),
        redirect_to: oauth_redirect_uri(
          error: "invalid_scope",
          error_description: Rex.t(
            :"action.pipe.oauth.scope_invalid",
            scope: scope
          ),
          state: state
        ).to_s,
        state: state
      })
    end

    def do_oauth_handle_errors(error)
      json({
        error: "server_error",
        error_description: Rex.t(
          :"action.pipe.oauth.server_error",
          message: error.message
        ),
        redirect_to: oauth_redirect_uri(
          error: "server_error",
          error_description: Rex.t(
            :"action.pipe.oauth.server_error",
            message: error.message
          ),
          state: state
        ).to_s,
        state: state
      })
    end

    def do_oauth_require_authorization_params_failed
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

    # @[Override]
    private def has_duplicate_params
      has_duplicate_params(params.from_form_data)
    end
  end
end
