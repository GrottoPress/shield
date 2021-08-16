module Shield::DeletePasswordResetsAfterResetPassword
  macro included
    private def end_password_resets(user : Shield::User)
      PasswordResetQuery.new.user_id(user.id).delete
    end
  end
end
