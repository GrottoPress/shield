module Shield::EndUserLogins # User::SaveOperation
  macro included
    needs current_login : Login?

    after_save end_logins

    private def end_logins(user : Shield::User)
      query = LoginQuery.new.user_id(user.id).is_active
      current_login.try { |login| query = query.id.not.eq(login.id) }
      query.update(inactive_at: Time.utc)
    end
  end
end
