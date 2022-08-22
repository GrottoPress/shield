# Implements the OAuth 2.0 authorization framework as defined
# in [RFC 6749](https://datatracker.ietf.org/doc/html/rfc6749)
module Shield::Api::OauthAccessTokenPipes
  macro included
    include Shield::OauthPipes

    def oauth_require_access_token_params
      if grant_type && code
        continue
      else
        response.status_code = 400
        do_oauth_require_access_token_params_failed
      end
    end

    def oauth_validate_grant_type
      if !grant_type || grant_type == "authorization_code"
        continue
      else
        response.status_code = 400
        do_oauth_validate_grant_type_failed
      end
    end

    def oauth_validate_code
      if !oauth_client? || oauth_authorization?
        continue
      else
        response.status_code = 400
        do_oauth_validate_code_failed
      end
    end

    def oauth_validate_client_secret
      if !oauth_client? ||
        oauth_client.public? ||
        OauthClientHeaders.new(request).verify? ||
        OauthClientParams.new(client_secret, client_id).verify?

        continue
      else
        send_invalid_client_secret_response
        do_oauth_validate_client_secret_failed
      end
    end

    def oauth_check_multiple_client_auth
      if !oauth_client? ||
        oauth_client.public? ||
        !OauthClientCredentials.from_headers?(request) ||
        !OauthClientCredentials.from_params?(client_secret, client_id)

        continue
      else
        response.status_code = 400
        do_oauth_check_multiple_client_auth_failed
      end
    end

    def do_oauth_validate_client_id_failed
      json({
        error: "invalid_client",
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
      json({
        error: "invalid_request",
        error_description: Rex.t(:"action.pipe.oauth.duplicate_params"),
      })
    end

    def do_oauth_validate_scope_failed
      json({
        error: "invalid_scope",
        error_description: Rex.t(
          :"action.pipe.oauth.scope_invalid",
          scope: scope
        ),
      })
    end

    def do_oauth_handle_errors(error)
      json({
        error: "server_error",
        error_description: Rex.t(
          :"action.pipe.oauth.server_error",
          message: error.message
        ),
      })
    end

    def do_oauth_validate_client_secret_failed
      json({
        error: "invalid_client",
        error_description: Rex.t(
          :"action.pipe.oauth.client_auth_failed",
          client_id: client_id
        )
      })
    end

    def do_oauth_require_access_token_params_failed
      json({
        error: "invalid_request",
        error_description: Rex.t(:"action.pipe.oauth.params_missing")
      })
    end

    def do_oauth_validate_grant_type_failed
      json({
        error: "unsupported_grant_type",
        error_description: Rex.t(
          :"action.pipe.oauth.grant_type_invalid",
          grant_type: grant_type
        )
      })
    end

    def do_oauth_validate_code_failed
      json({
        error: "invalid_grant",
        error_description: Rex.t(:"action.pipe.oauth.auth_code_invalid"),
      })
    end

    def do_oauth_check_multiple_client_auth_failed
      json({
        error: "invalid_request",
        error_description: Rex.t(:"action.pipe.oauth.multiple_client_auth"),
      })
    end

    private def send_invalid_client_secret_response
      response.status_code = 401
      response.headers["WWW-Authenticate"] = %(Basic realm="oauth")
    end
  end
end
