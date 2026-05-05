module Shield::DeleteUserLoginsOnPasswordChange
  macro included
    private def end_logins(user : Shield::User)
      return unless password_digest.changed?

      DeleteUserLogins.update!(user, current_login: current_login)
    end
  end
end
