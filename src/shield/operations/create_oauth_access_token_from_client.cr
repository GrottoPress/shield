module Shield::CreateOauthAccessTokenFromClient
  macro included
    getter refresh_token : String?

    needs oauth_client : OauthClient

    include Lucille::Activate
    include Shield::SetToken

    before_save do
      set_inactive_at
      set_name
      set_user_id
      set_oauth_client_id
    end

    include Shield::ValidateOauthAccessToken

    private def set_inactive_at
      Shield.settings.oauth_access_token_expiry.try do |expiry|
        active_at.value.try { |value| inactive_at.value = value + expiry }
      end
    end

    private def set_name
      return unless oauth_client.status.active?
      name.value = "OAuth access token -- Client #{oauth_client.id}"
    end

    private def set_user_id
      return unless oauth_client.status.active?
      user_id.value = oauth_client.user_id
    end

    private def set_oauth_client_id
      return unless oauth_client.status.active?
      oauth_client_id.value = oauth_client.id
    end
  end
end
