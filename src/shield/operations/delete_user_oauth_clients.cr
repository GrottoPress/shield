module Shield::DeleteUserOauthClients
  macro included
    after_commit delete_oauth_clients

    private def delete_oauth_clients(user : Shield::User)
      OauthClientQuery.new.user_id(user.id).delete
    end
  end
end
