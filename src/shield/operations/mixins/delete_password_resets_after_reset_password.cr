module Shield::DeletePasswordResetsAfterResetPassword
  macro included
    after_commit delete_password_resets

    private def end_password_resets(password_reset : Shield::PasswordReset)
    end

    private def delete_password_resets(password_reset : Shield::PasswordReset)
      PasswordResetQuery.new.user_id(password_reset.user_id).delete
    end
  end
end
