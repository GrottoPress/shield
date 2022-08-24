module Shield::RevokeOauthAuthorizationAfterDeleteOauthPermission
  macro included
    after_save revoke_oauth_authorizations

    private def delete_oauth_authorizations(user : Shield::User)
    end

    private def revoke_oauth_authorizations(user : Shield::User)
      OauthAuthorizationQuery.new
        .user_id(user.id)
        .oauth_client_id(oauth_client.id)
        .is_active
        .update(inactive_at: Time.utc)
    end
  end
end
