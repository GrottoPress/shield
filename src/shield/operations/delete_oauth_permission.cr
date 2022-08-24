module Shield::DeleteOauthPermission
  macro included
    needs oauth_client : OauthClient

    after_commit delete_permission
    after_commit delete_oauth_authorizations

    private def delete_permission(user : Shield::User)
      BearerLoginQuery.new
        .user_id(user.id)
        .oauth_client_id(oauth_client.id)
        .delete
    end

    private def delete_oauth_authorizations(user : Shield::User)
      OauthAuthorizationQuery.new
        .user_id(user.id)
        .oauth_client_id(oauth_client.id)
        .delete
    end
  end
end
