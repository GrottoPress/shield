module Shield::RevokeOauthPermission
  macro included
    needs user : User

    after_save revoke_permission
    after_save revoke_oauth_grants

    private def revoke_permission(oauth_client : Shield::OauthClient)
      BearerLoginQuery.new
        .user_id(user.id)
        .oauth_client_id(oauth_client.id)
        .is_active
        .update(inactive_at: Time.utc)
    end

    private def revoke_oauth_grants(oauth_client : Shield::OauthClient)
      OauthGrantQuery.new
        .user_id(user.id)
        .oauth_client_id(oauth_client.id)
        .is_active
        .update(inactive_at: Time.utc)
    end
  end
end
