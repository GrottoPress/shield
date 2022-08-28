# Implements the OAuth 2.0 authorization framework as defined
# in [RFC 6749](https://datatracker.ietf.org/doc/html/rfc6749)
module Shield::Api::Oauth::Token::Pipes
  macro included
    include Shield::Oauth::Pipes

    def oauth_require_access_token_params
      if !grant_type ||
        (oauth_grant_type.authorization_code? && !code) ||
        (oauth_grant_type.refresh_token? && !refresh_token)

        response.status_code = 400
        do_oauth_require_access_token_params_failed
      else
        continue
      end
    end

    def oauth_validate_grant_type
      if !grant_type || oauth_grant_type.valid?
        continue
      else
        response.status_code = 400
        do_oauth_validate_grant_type_failed
      end
    end

    def oauth_validate_code
      if !grant_type ||
        !grant_type.in?({
          OauthGrantType::AUTHORIZATION_CODE,
          OauthGrantType::REFRESH_TOKEN
        }) ||
        !oauth_client? ||
        oauth_authorization_params.verify?(oauth_client)

        continue
      else
        response.status_code = 400
        do_oauth_validate_code_failed
      end
    end

    def oauth_validate_code_verifier
      if !grant_type ||
        !oauth_grant_type.authorization_code? ||
        oauth_authorization_params.verify_pkce?(code_verifier)

        continue
      else
        response.status_code = 400
        do_oauth_validate_code_verifier_failed
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
        !OauthClientCredentials.from_params?(params)

        continue
      else
        response.status_code = 400
        do_oauth_check_multiple_client_auth_failed
      end
    end

    def oauth_require_confidential_client
      if !grant_type ||
        !oauth_grant_type.client_credentials? ||
        !oauth_client? ||
        oauth_client.confidential?

        continue
      else
        response.status_code = 400
        do_oauth_require_confidential_client_failed
      end
    end

    def oauth_validate_redirect_uri
      if !grant_type ||
        !oauth_grant_type.authorization_code? ||
        !oauth_client? ||
        oauth_client.redirect_uri == redirect_uri

        continue
      else
        response.status_code = 400
        do_oauth_validate_redirect_uri_failed
      end
    end

    # Requires logged in, but confidential clients may use their
    # credentials instead.
    #
    # IMPORTANT!
    #
    # Force public clients to always require login, whether or not they
    # present client credentials, because the `#oauth_validate_client_secret`
    # pipe skips validation for public clients.
    def oauth_maybe_require_logged_in
      if !oauth_client?
        continue
      elsif oauth_client.public? # <= IMPORTANT!
        oauth_require_logged_in
      elsif OauthClientCredentials.from_headers?(request) ||
        OauthClientCredentials.from_params?(params)

        oauth_validate_client_secret
      else
        oauth_require_logged_in
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

    def do_oauth_validate_code_verifier_failed
      json({
        error: "invalid_grant",
        error_description: Rex.t(:"action.pipe.oauth.code_verifier_invalid"),
      })
    end

    def do_oauth_check_multiple_client_auth_failed
      json({
        error: "invalid_request",
        error_description: Rex.t(:"action.pipe.oauth.multiple_client_auth"),
      })
    end

    def do_oauth_require_confidential_client_failed
      json({
        error: "invalid_client",
        error_description: Rex.t(
          :"action.pipe.oauth.client_public",
          client_id: client_id
        )
      })
    end

    private def send_invalid_client_secret_response
      response.status_code = 401
      response.headers["WWW-Authenticate"] = %(Basic realm="oauth")
    end

    private getter oauth_authorization_params do
      token = oauth_grant_type.refresh_token? ? refresh_token : code
      OauthAuthorizationParams.new(token)
    end

    private def oauth_grant_type
      OauthGrantType.new(grant_type)
    end
  end
end
