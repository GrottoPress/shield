module Shield::RevokeOauthPermission
  macro included
    needs oauth_client : OauthClient

    after_save revoke_permission

    private def revoke_permission(user : Shield::User)
      BearerLoginQuery.new
        .user_id(user.id)
        .oauth_client_id(oauth_client.id)
        .is_active
        .update(inactive_at: Time.utc)
    end
  end
end
