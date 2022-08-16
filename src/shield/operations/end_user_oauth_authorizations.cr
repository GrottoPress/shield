module Shield::EndUserOauthAuthorizations
  macro included
    after_save end_oauth_authorizations

    private def end_oauth_authorizations(user : Shield::User)
      OauthAuthorizationQuery.new
        .user_id(user.id)
        .is_active
        .update(inactive_at: Time.utc)
    end
  end
end
