module Shield::DeleteOauthPermission
  macro included
    needs oauth_client : OauthClient

    after_commit delete_permission

    private def delete_permission(user : Shield::User)
      BearerLoginQuery.new
        .user_id(user.id)
        .oauth_client_id(oauth_client.id)
        .delete
    end
  end
end
