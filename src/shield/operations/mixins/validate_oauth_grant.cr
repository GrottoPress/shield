module Shield::ValidateOauthGrant
  macro included
    before_save do
      ensure_scopes_unique

      validate_code_challenge_method_allowed
      validate_code_digest_required

      validate_oauth_client_id_required
      validate_oauth_client_exists

      validate_scopes_required
      validate_scopes_not_empty
      validate_scopes_valid

      validate_type_required
      validate_type_valid

      validate_user_id_required
    end

    include Lucille::ValidateStatus
    include Lucille::ValidateUserExists

    private def ensure_scopes_unique
      scopes.value = scopes.value.try(&.uniq)
    end

    private def validate_code_challenge_method_allowed
      metadata.value.try do |value|
        pkce = OauthGrantPkce.new(value)
        return if pkce.challenge_method.allowed?

        metadata.add_error Rex.t(
          :"operation.error.code_challenge_method_invalid",
          method: pkce.challenge_method
        )
      end
    end

    private def validate_code_digest_required
      validate_required code_digest,
        message: Rex.t(:"operation.error.oauth.code_required")
    end

    private def validate_oauth_client_id_required
      validate_required oauth_client_id,
        message: Rex.t(:"operation.error.oauth.client_id_required")
    end

    private def validate_scopes_required
      validate_required scopes,
        message: Rex.t(:"operation.error.bearer_scopes_required")
    end

    private def validate_scopes_not_empty
      scopes.value.try do |value|
        return unless value.empty?
        scopes.add_error Rex.t(:"operation.error.bearer_scopes_required")
      end
    end

    private def validate_scopes_valid
      scopes.value.try do |value|
        allowed_scopes = Shield.settings.oauth_access_token_scopes_allowed
        return if value.all? &.in?(allowed_scopes)

        scopes.add_error Rex.t(:"operation.error.bearer_scopes_invalid")
      end
    end

    private def validate_oauth_client_exists
      return unless oauth_client_id.changed?

      validate_foreign_key oauth_client_id,
        query: OauthClientQuery,
        message: Rex.t(
          :"operation.error.oauth.client_not_found",
          oauth_client_id: oauth_client_id.value
        )
    end

    private def validate_type_required
      validate_required type,
        message: Rex.t(:"operation.error.grant_type_required")
    end

    private def validate_type_valid
      type.value.try do |value|
        return if value.valid?
        type.add_error Rex.t(:"operation.error.grant_type_invalid")
      end
    end

    private def validate_user_id_required
      validate_required user_id,
        message: Rex.t(:"operation.error.user_id_required")
    end
  end
end
