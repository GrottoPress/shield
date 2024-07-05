module Shield::DeleteGrantsAfterRevokeOauthPermission
  macro included
    after_save delete_oauth_grants

    private def revoke_oauth_grants(oauth_client : Shield::OauthClient)
    end

    private def delete_oauth_grants(oauth_client : Shield::OauthClient)
      OauthGrantQuery.new
        .user_id(user.id)
        .oauth_client_id(oauth_client.id)
        .delete
    end
  end
end
