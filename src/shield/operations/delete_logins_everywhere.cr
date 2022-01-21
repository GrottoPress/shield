module Shield::DeleteLoginsEverywhere
  macro included
    needs current_login : Login?

    after_save delete_logins_everywhere

    private def delete_logins_everywhere(user : Shield::User)
      query = LoginQuery.new.user_id(user.id)
      current_login.try { |login| query = query.id.not.eq(login.id) }
      query.delete
    end
  end
end
