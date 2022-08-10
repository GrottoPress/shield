module Shield::DeactivateOauthClient
  macro included
    include Lucille::Deactivate

    after_save revoke_access_tokens

    private def revoke_access_tokens(oauth_client : Shield::OauthClient)
      BearerLoginQuery.new
        .oauth_client_id(oauth_client.id)
        .is_active
        .update(inactive_at: Time.utc)
    end
  end
end
