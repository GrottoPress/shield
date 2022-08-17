module Shield::DeleteUserOauthAccessTokens
  macro included
    after_save delete_access_tokens

    private def delete_access_tokens(user : Shield::User)
      BearerLoginQuery.new.user_id(user.id).oauth_client_id.is_not_nil.delete
    end
  end
end
