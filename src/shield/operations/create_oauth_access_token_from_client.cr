module Shield::CreateOauthAccessTokenFromClient # BearerLogin::SaveOperation
  macro included
    getter credentials : OauthGrantCredentials?

    needs oauth_client : OauthClient

    include Lucille::Activate
    include Shield::SetToken

    before_save do
      set_inactive_at
      set_name
      set_user_id
      set_oauth_client_id
    end

    after_save create_oauth_grant

    include Shield::ValidateOauthAccessToken

    {% if Avram::Model.all_subclasses.find(&.name.== :UserOptions.id) %}
      include Shield::NotifyOauthAccessToken
    {% elsif Lucille::JSON.includers.find(&.name.== :UserSettings.id) %}
      include Shield::NotifyOauthAccessTokenIfSet
    {% end %}

    private def set_inactive_at
      Shield.settings.oauth_access_token_expiry.try do |expiry|
        active_at.value.try { |value| inactive_at.value = value + expiry }
      end
    end

    private def set_name
      return unless oauth_client.status.active?

      name.value = Rex.t(
        :"operation.misc.oauth.access_token_name",
        grant_type: OauthGrantType.client_credentials,
        client_id: oauth_client.id,
        user_id: oauth_client.user_id
      )
    end

    private def set_user_id
      return unless oauth_client.status.active?
      user_id.value = oauth_client.user_id
    end

    private def set_oauth_client_id
      return unless oauth_client.status.active?
      oauth_client_id.value = oauth_client.id
    end

    # This is not required. Doing it just to have a log of the grant.
    private def create_oauth_grant(bearer_login : BearerLogin)
      now = Time.utc

      StartOauthGrant.create!(
        granted: true,
        type: OauthGrantType.client_credentials,
        scopes: bearer_login.scopes,
        oauth_client: oauth_client,
        user: oauth_client.user,
        active_at: now,
        inactive_at: now + 1.second,
        success: true
      )
    end
  end
end
