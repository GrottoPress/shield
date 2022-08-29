module Shield::DeleteGrantsAfterDeactivateOauthClient
  macro included
    after_commit delete_oauth_grants

    private def end_oauth_grants(oauth_client : Shield::OauthClient)
    end

    private def delete_oauth_grants(oauth_client : Shield::OauthClient)
      OauthGrantQuery.new.oauth_client_id(oauth_client.id).delete
    end
  end
end
