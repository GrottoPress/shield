module Shield::CreateOauthAccessTokenFromAuthorization
  # IMPORTANT
  #
  # Revoke access tokens if authorization code used more than once,
  # to mitigate replay attacks.
  macro included
    needs oauth_authorization : OauthAuthorization

    include Lucille::Activate
    include Shield::SetToken

    before_save do
      revoke_access_tokens # <= IMPORTANT

      set_inactive_at
      set_name
      set_scopes
      set_user_id
      set_oauth_client_id
    end

    after_save end_oauth_authorization

    include Shield::ValidateOauthAccessToken

    private def set_inactive_at
      Shield.settings.oauth_access_token_expiry.try do |expiry|
        active_at.value.try { |value| inactive_at.value = value + expiry }
      end
    end

    private def set_name
      return unless oauth_authorization.status.active?

      name.value = "OAuth access token --
        Authorization #{oauth_authorization.id}"
    end

    private def set_scopes
      return unless oauth_authorization.status.active?
      scopes.value = oauth_authorization.scopes
    end

    private def set_user_id
      return unless oauth_authorization.status.active?
      user_id.value = oauth_authorization.user_id
    end

    private def set_oauth_client_id
      return unless oauth_authorization.status.active?
      oauth_client_id.value = oauth_authorization.oauth_client_id
    end

    private def revoke_access_tokens
      return if oauth_authorization.status.active?

      BearerLoginQuery.new
        .user_id(oauth_authorization.user_id)
        .oauth_client_id(oauth_authorization.oauth_client_id)
        .is_active
        .update(inactive_at: Time.utc)
    end

    private def end_oauth_authorization(bearer_login : Shield::BearerLogin)
      EndOauthAuthorization.update!(oauth_authorization, success: true)
    end
  end
end
