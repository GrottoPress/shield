module Shield::RevokeOauthPermission
  macro included
    needs oauth_client : OauthClient

    after_save revoke_permission
    after_save revoke_oauth_grants

    private def revoke_permission(user : Shield::User)
      BearerLoginQuery.new
        .user_id(user.id)
        .oauth_client_id(oauth_client.id)
        .is_active
        .update(inactive_at: Time.utc)
    end

    private def revoke_oauth_grants(user : Shield::User)
      OauthGrantQuery.new
        .user_id(user.id)
        .oauth_client_id(oauth_client.id)
        .is_active
        .update(inactive_at: Time.utc)
    end
  end
end
