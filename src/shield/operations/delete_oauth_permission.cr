module Shield::DeleteOauthPermission # OauthClient::SaveOperation
  macro included
    needs user : User

    after_commit delete_permission
    after_commit delete_oauth_grants

    private def delete_permission(oauth_client : Shield::OauthClient)
      BearerLoginQuery.new
        .user_id(user.id)
        .oauth_client_id(oauth_client.id)
        .delete
    end

    private def delete_oauth_grants(oauth_client : Shield::OauthClient)
      OauthGrantQuery.new
        .user_id(user.id)
        .oauth_client_id(oauth_client.id)
        .delete
    end
  end
end
