module Shield::DeleteOauthAuthorizationsAfterDeactivateOauthClient
  macro included
    after_commit delete_oauth_authorizations

    private def end_oauth_authorizations(oauth_client : Shield::OauthClient)
    end

    private def delete_oauth_authorizations(oauth_client : Shield::OauthClient)
      OauthAuthorizationQuery.new.oauth_client_id(oauth_client.id).delete
    end
  end
end
