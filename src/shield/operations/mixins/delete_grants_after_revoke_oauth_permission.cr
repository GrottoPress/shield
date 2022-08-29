module Shield::DeleteGrantsAfterRevokeOauthPermission
  macro included
    after_commit delete_oauth_grants

    private def revoke_oauth_grants(user : Shield::User)
    end

    private def delete_oauth_grants(user : Shield::User)
      OauthGrantQuery.new
        .user_id(user.id)
        .oauth_client_id(oauth_client.id)
        .delete
    end
  end
end
