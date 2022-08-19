module Shield::ValidateOauthAuthorization
  macro included
    before_save do
      ensure_scopes_unique

      validate_code_challenge_method_allowed
      validate_code_digest_required
      validate_pkce_required

      validate_oauth_client_id_required
      validate_oauth_client_exists

      validate_scopes_required
      validate_scopes_not_empty
      validate_scopes_valid

      validate_user_id_required
      validate_user_exists
    end

    include Lucille::ValidateStatus

    private def ensure_scopes_unique
      scopes.value = scopes.value.try(&.uniq)
    end

    private def validate_code_challenge_method_allowed
      pkce.value.try do |value|
        allowed_methods = Shield.settings.oauth_code_challenge_methods_allowed
        return if value.code_challenge_method.in?(allowed_methods)

        pkce.add_error Rex.t(
          :"operation.error.code_challenge_method_invalid",
          method: value
        )
      end
    end

    private def validate_code_digest_required
      validate_required code_digest,
        message: Rex.t(:"operation.error.auth_code_required")
    end

    private def validate_pkce_required
      return if pkce.value

      oauth_client_id.value.try do |value|
        OauthClientQuery.new.id(value).first?.try do |oauth_client|
          return unless oauth_client.public?
          pkce.add_error Rex.t(:"operation.error.pkce_required")
        end
      end
    end

    private def validate_oauth_client_id_required
      validate_required oauth_client_id,
        message: Rex.t(:"operation.error.oauth_client_id_required")
    end

    private def validate_scopes_required
      validate_required scopes,
        message: Rex.t(:"operation.error.bearer_scopes_required")
    end

    private def validate_scopes_not_empty
      scopes.value.try do |value|
        return unless value.empty?
        scopes.add_error Rex.t(:"operation.error.bearer_scopes_empty")
      end
    end

    private def validate_scopes_valid
      scopes.value.try do |value|
        allowed_scopes = Shield.settings.bearer_login_scopes_allowed
        return if value.all? &.in?(allowed_scopes)

        scopes.add_error Rex.t(:"operation.error.bearer_scopes_invalid")
      end
    end

    private def validate_oauth_client_exists
      return unless oauth_client_id.changed?

      validate_foreign_key oauth_client_id,
        query: OauthClientQuery,
        message: Rex.t(
          :"operation.error.oauth_client_not_found",
          oauth_client_id: oauth_client_id.value
        )
    end

    private def validate_user_id_required
      validate_required user_id,
        message: Rex.t(:"operation.error.user_id_required")
    end

    private def validate_user_exists
      return unless user_id.changed?

      validate_foreign_key user_id,
        query: UserQuery,
        message: Rex.t(
          :"operation.error.user_not_found",
          user_id: user_id.value
        )
    end
  end
end
