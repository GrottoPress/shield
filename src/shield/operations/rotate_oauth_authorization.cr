module Shield::RotateOauthAuthorization
  macro included
    needs oauth_authorization : OauthAuthorization
    needs oauth_grant_type : OauthGrantType

    include Lucille::Activate
    include Shield::SetOauthAuthorizationCode

    before_save do
      set_oauth_client_id
      set_user_id
      set_scopes
      set_inactive_at
      set_success
    end

    after_save end_oauth_authorization

    include Shield::ValidateOauthAuthorization

    private def validate_user_exists
    end

    private def validate_oauth_client_exists
    end

    private def validate_pkce_required
    end

    private def set_oauth_client_id
      return unless oauth_authorization.status.active?
      oauth_client_id.value = oauth_authorization.oauth_client_id
    end

    private def set_user_id
      return unless oauth_authorization.status.active?
      user_id.value = oauth_authorization.user_id
    end

    private def set_scopes
      return unless oauth_authorization.status.active?
      scopes.value = oauth_authorization.scopes
    end

    private def set_inactive_at
      Shield.settings.oauth_refresh_token_expiry.try do |expiry|
        active_at.value.try { |value| inactive_at.value = value + expiry }
      end
    end

    private def set_success
      success.value = false
    end

    private def end_oauth_authorization(__ : OauthAuthorization)
      EndOauthAuthorizationGracefully.update!(
        oauth_authorization,
        success: true,
        oauth_grant_type: oauth_grant_type
      )
    end
  end
end
