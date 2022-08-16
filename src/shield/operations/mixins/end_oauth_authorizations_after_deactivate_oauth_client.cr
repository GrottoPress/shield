module Shield::EndOauthAuthAuthorizationsAfterDeactivateOauthClient
  macro included
    after_save end_oauth_authorizations

    private def end_oauth_authorizations(oauth_client : Shield::OauthClient)
      OauthAuthorizationQuery.new
        .oauth_client_id(oauth_client.id)
        .is_active
        .update(inactive_at: Time.utc)
    end
  end
end
