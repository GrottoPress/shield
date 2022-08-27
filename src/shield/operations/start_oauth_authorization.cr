module Shield::StartOauthAuthorization
  macro included
    getter code do
      Random::Secure.urlsafe_base64(24)
    end

    attribute granted : Bool
    attribute code_challenge : String
    attribute code_challenge_method : String

    attribute redirect_uri : String
    attribute response_type : String
    attribute state : String

    include Lucille::Activate
    include Lucille::SetUserIdFromUser
    include Shield::SetOauthClientIdFromOauthClient

    before_save do
      set_inactive_at
      set_code
      set_success
      set_code_challenge
      set_code_challenge_method

      validate_authorization_granted
      validate_redirect_uri_matches
      validate_response_type_valid
    end

    include Shield::ValidateOauthAuthorization

    private def validate_user_exists
      return if user
      previous_def
    end

    private def validate_oauth_client_exists
      return if oauth_client
      previous_def
    end

    private def validate_pkce_required
      return if pkce.value

      oauth_client!.try do |client|
        return unless client.public?
        pkce.add_error Rex.t(:"operation.error.pkce_required")
      end
    end

    private def validate_authorization_granted
      return if granted.value
      granted.add_error Rex.t(:"operation.error.authorization_denied")
    end

    private def validate_redirect_uri_matches
      redirect_uri.value.try do |value|
        oauth_client!.try do |client|
          return if value == client.redirect_uri
          redirect_uri.add_error Rex.t(:"operation.error.redirect_uri_invalid")
        end
      end
    end

    private def validate_response_type_valid
      response_type.value.try do |value|
        return if value == "code"
        response_type.add_error Rex.t(:"operation.error.response_type_invalid")
      end
    end

    private def set_inactive_at
      expiry = Shield.settings.oauth_authorization_code_expiry
      active_at.value.try { |value| inactive_at.value = value + expiry }
    end

    private def set_code
      code_digest.value = Sha256Hash.new(code).hash
    end

    private def set_success
      success.value = false
    end

    private def set_code_challenge
      code_challenge.value.try do |value|
        values = {code_challenge: value}

        pkce.value.try do |_pkce|
          return pkce.value = _pkce.merge(**values)
        end

        pkce.value = OauthAuthorizationPkce.from_json(values.to_json)
      end
    end

    private def set_code_challenge_method
      code_challenge_method.value.try do |value|
        values = {code_challenge_method: value}

        pkce.value.try do |_pkce|
          return pkce.value = _pkce.merge(**values)
        end

        pkce.value = OauthAuthorizationPkce.from_json(values.to_json)
      end
    end
  end
end
