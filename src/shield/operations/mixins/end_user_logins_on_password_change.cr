module Shield::EndUserLoginsOnPasswordChange
  macro included
    needs current_login : Login?

    after_save end_logins

    private def end_logins(user : Shield::User)
      return unless password_digest.changed?

      LogOutEverywhere.update!(user, current_login: current_login)
    end
  end
end
