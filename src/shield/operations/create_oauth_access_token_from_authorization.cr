module Shield::CreateOauthAccessTokenFromAuthorization
  # IMPORTANT
  #
  # Revoke access tokens if authorization code used more than once,
  # to mitigate replay attacks.
  macro included
    needs oauth_authorization : OauthAuthorization?

    include Lucille::Activate
    include Shield::SetToken

    before_save do
      revoke_access_tokens # <= IMPORTANT

      set_inactive_at
      set_name
      set_scopes
      set_user_id
      set_oauth_client_id

      validate_oauth_client_id_required
    end

    after_save end_oauth_authorization

    include Shield::ValidateBearerLogin

    private def validate_oauth_client_id_required
      validate_required oauth_client_id,
        message: Rex.t(:"operation.error.oauth_client_id_required")
    end

    private def set_inactive_at
      Shield.settings.oauth_access_token_expiry.try do |expiry|
        active_at.value.try { |value| inactive_at.value = value + expiry }
      end
    end

    private def set_name
      oauth_authorization.try do |authorization|
        return unless authorization.status.active?
        name.value = "OAuth access token #{authorization.id}"
      end
    end

    private def set_scopes
      oauth_authorization.try do |authorization|
        return unless authorization.status.active?
        scopes.value = authorization.scopes
      end
    end

    private def set_user_id
      oauth_authorization.try do |authorization|
        return unless authorization.status.active?
        user_id.value = authorization.user_id
      end
    end

    private def set_oauth_client_id
      oauth_authorization.try do |authorization|
        return unless authorization.status.active?
        oauth_client_id.value = authorization.oauth_client_id
      end
    end

    private def revoke_access_tokens
      oauth_authorization.try do |authorization|
        return if authorization.status.active?

        BearerLoginQuery.new
          .user_id(authorization.user_id)
          .oauth_client_id(authorization.oauth_client_id)
          .is_active
          .update(inactive_at: Time.utc)
      end
    end

    private def end_oauth_authorization(bearer_login : Shield::BearerLogin)
      oauth_authorization.try do |authorization|
        EndOauthAuthorization.update!(authorization, success: true)
      end
    end
  end
end
