module Shield::DeleteOauthAuthorizationAfterRevokeOauthPermission
  macro included
    after_commit delete_oauth_authorizations

    private def revoke_oauth_authorizations(user : Shield::User)
    end

    private def delete_oauth_authorizations(user : Shield::User)
      OauthAuthorizationQuery.new
        .user_id(user.id)
        .oauth_client_id(oauth_client.id)
        .delete
    end
  end
end
