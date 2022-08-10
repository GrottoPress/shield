module Shield::DeleteAccessTokensAfterDeactivateOauthClient
  macro included
    after_commit delete_access_tokens

    private def revoke_access_tokens(oauth_client : Shield::OauthClient)
    end

    private def delete_access_tokens(oauth_client : Shield::OauthClient)
      BearerLoginQuery.new.oauth_client_id(oauth_client.id).delete
    end
  end
end
