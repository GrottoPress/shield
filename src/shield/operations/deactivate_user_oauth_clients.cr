module Shield::DeactivateUserOauthClients # User::SaveOperation
  macro included
    after_save deactivate_oauth_clients

    private def deactivate_oauth_clients(user : Shield::User)
      OauthClientQuery.new
        .user_id(user.id)
        .is_active
        .update(inactive_at: Time.utc)
    end
  end
end
