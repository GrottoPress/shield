module Shield::RevokeUserOauthAccessTokens
  macro included
    after_save revoke_access_tokens

    private def revoke_access_tokens(user : Shield::User)
      BearerLoginQuery.new
        .user_id(user.id)
        .oauth_client_id.is_not_nil
        .is_active
        .update(inactive_at: Time.utc)
    end
  end
end
