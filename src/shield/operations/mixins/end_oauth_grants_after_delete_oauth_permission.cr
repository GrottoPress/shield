module Shield::EndOauthGrantsAfterDeleteOauthPermission
  macro included
    after_save end_oauth_grants

    private def delete_oauth_grants(user : Shield::User)
    end

    private def end_oauth_grants(user : Shield::User)
      OauthGrantQuery.new
        .user_id(user.id)
        .oauth_client_id(oauth_client.id)
        .is_active
        .update(inactive_at: Time.utc)
    end
  end
end
