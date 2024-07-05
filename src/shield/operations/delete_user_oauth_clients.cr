module Shield::DeleteUserOauthClients # User::SaveOperation
  macro included
    after_save delete_oauth_clients

    private def delete_oauth_clients(user : Shield::User)
      OauthClientQuery.new.user_id(user.id).delete
    end
  end
end
