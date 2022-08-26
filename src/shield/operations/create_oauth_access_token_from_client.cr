module Shield::CreateOauthAccessTokenFromClient
  macro included
    needs oauth_client : OauthClient

    include Lucille::Activate
    include Shield::SetToken

    before_save do
      set_inactive_at
      set_name
      set_user_id
      set_oauth_client_id

      validate_oauth_client_id_required
    end

    include Shield::ValidateBearerLogin

    private def validate_name_unique
    end

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
