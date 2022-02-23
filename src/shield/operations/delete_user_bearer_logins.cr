module Shield::DeleteUserBearerLogins
  macro included
    needs current_bearer_login : BearerLogin?

    after_save delete_bearer_logins

    private def delete_bearer_logins(user : Shield::User)
      query = BearerLoginQuery.new.user_id(user.id)
      current_bearer_login.try { |login| query = query.id.not.eq(login.id) }
      query.delete
    end
  end
end
