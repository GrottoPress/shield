module Shield::EndOauthAuthGrantsAfterDeactivateOauthClient
  macro included
    after_save end_oauth_grants

    private def end_oauth_grants(oauth_client : Shield::OauthClient)
      OauthGrantQuery.new
        .oauth_client_id(oauth_client.id)
        .is_active
        .update(inactive_at: Time.utc)
    end
  end
end
