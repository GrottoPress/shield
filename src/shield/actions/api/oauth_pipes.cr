# Implements the OAuth 2.0 authorization framework as defined
# in [RFC 6749](https://datatracker.ietf.org/doc/html/rfc6749)
module Shield::Api::OauthPipes
  macro included
    include Shield::OauthPipes

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
  end
end
