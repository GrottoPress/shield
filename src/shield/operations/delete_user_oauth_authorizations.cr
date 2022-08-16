module Shield::DeleteUserOauthAuthorizations
  macro included
    after_commit delete_oauth_authorizations

    private def delete_oauth_authorizations(user : Shield::User)
      OauthAuthorizationQuery.new.user_id(user.id).delete
    end
  end
end
