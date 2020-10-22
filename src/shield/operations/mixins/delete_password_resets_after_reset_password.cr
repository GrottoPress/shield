module Shield::DeletePasswordResetsAfterResetPassword
  macro included
    private def end_password_resets(user : User)
      PasswordResetQuery.new.user_id(user.id).delete
    end
  end
end
