module Shield::ValidateOauthAccessToken
  macro included
    include Shield::ValidateBearerLogin

    skip_default_validations

    before_save do
      validate_oauth_client_id_required
    end

    private def validate_name_unique
    end

    private def validate_name_valid
    end

    private def validate_scopes_valid
      scopes.value.try do |value|
        allowed_scopes = Shield.settings.oauth_access_token_scopes_allowed
        return if value.all? &.in?(allowed_scopes)

        scopes.add_error Rex.t(:"operation.error.bearer_scopes_invalid")
      end
    end

    private def validate_oauth_client_id_required
      validate_required oauth_client_id,
        message: Rex.t(:"operation.error.oauth.client_id_required")
    end
  end
end
