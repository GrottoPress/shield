module Shield::DeleteUserLoginsOnPasswordChange
  macro included
    private def log_out_everywhere(user : Shield::User)
      return unless password_digest.changed?

      DeleteLoginsEverywhere.update!(user, current_login: current_login)
    end
  end
end
