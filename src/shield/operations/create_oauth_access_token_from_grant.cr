module Shield::CreateOauthAccessTokenFromGrant # BearerLogin::SaveOperation
  # IMPORTANT
  #
  # Revoke access tokens if authorization used more than once,
  # to mitigate replay attacks.
  macro included
    getter credentials : OauthGrantCredentials?

    needs oauth_grant : OauthGrant

    include Lucille::Activate
    include Shield::SetToken

    before_save do
      revoke_access_tokens # <= IMPORTANT

      set_inactive_at
      set_name
      set_refresh_token_grant_scopes
      set_authorization_code_grant_scopes
      set_user_id
      set_oauth_client_id
    end

    after_save end_oauth_grant
    after_save rotate_oauth_grant

    include Shield::ValidateOauthAccessToken

    private def set_inactive_at
      Shield.settings.oauth_access_token_expiry.try do |expiry|
        active_at.value.try { |value| inactive_at.value = value + expiry }
      end
    end

    private def set_name
      return unless oauth_grant.status.active?

      name.value = Rex.t(
        :"operation.misc.oauth.access_token_name",
        grant_type: oauth_grant.type,
        client_id: oauth_grant.oauth_client_id,
        user_id: oauth_grant.user_id
      )
    end

    private def set_refresh_token_grant_scopes
      return unless oauth_grant.type.refresh_token?
      return unless oauth_grant.status.active?

      scopes.value.try do |value|
        return if !value.empty? && value.all?(&.in? oauth_grant.scopes)
      end

      scopes.value = oauth_grant.scopes
    end

    private def set_authorization_code_grant_scopes
      return unless oauth_grant.type.authorization_code?
      return unless oauth_grant.status.active?

      scopes.value = oauth_grant.scopes
    end

    private def set_user_id
      return unless oauth_grant.status.active?
      user_id.value = oauth_grant.user_id
    end

    private def set_oauth_client_id
      return unless oauth_grant.status.active?
      oauth_client_id.value = oauth_grant.oauth_client_id
    end

    private def revoke_access_tokens
      return if oauth_grant.status.active?

      BearerLoginQuery.new
        .user_id(oauth_grant.user_id)
        .oauth_client_id(oauth_grant.oauth_client_id)
        .is_active
        .update(inactive_at: Time.utc)
    end

    private def end_oauth_grant(__ : Shield::BearerLogin)
      return if Shield.settings.oauth_access_token_expiry

      EndOauthGrantGracefully.update!(oauth_grant, success: true)
    end

    private def rotate_oauth_grant(__ : Shield::BearerLogin)
      return unless Shield.settings.oauth_access_token_expiry

      operation = RotateOauthGrant.new(oauth_grant, success: true)
      operation.save!

      @credentials = operation.credentials
    end
  end
end
