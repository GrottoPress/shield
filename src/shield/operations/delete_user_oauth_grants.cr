module Shield::DeleteUserOauthGrants
  macro included
    after_commit delete_oauth_grants

    private def delete_oauth_grants(user : Shield::User)
      OauthGrantQuery.new.user_id(user.id).delete
    end
  end
end
