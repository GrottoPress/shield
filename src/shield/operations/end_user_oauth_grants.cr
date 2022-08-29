module Shield::EndUserOauthGrants
  macro included
    after_save end_oauth_grants

    private def end_oauth_grants(user : Shield::User)
      OauthGrantQuery.new
        .user_id(user.id)
        .is_active
        .update(inactive_at: Time.utc)
    end
  end
end
