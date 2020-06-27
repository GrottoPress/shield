module Shield::ResetPassword
  macro included
    include Shield::SavePassword

    needs password_reset : PasswordReset

    before_save do
      validate_required password
    end

    after_save delete_password_reset_token

    private def delete_password_reset_token(user : User)
      DeletePasswordResetToken.update!(password_reset)
    end
  end
end
