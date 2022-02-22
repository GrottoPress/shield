module Shield::EndUserLoginsOnPasswordChange
  macro included
    needs current_login : Login?

    after_save log_out_everywhere

    private def log_out_everywhere(user : Shield::User)
      return unless password_digest.changed?

      LogOutEverywhere.update!(user, current_login: current_login)
    end
  end
end
