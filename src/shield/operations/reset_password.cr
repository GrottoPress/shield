module Shield::ResetPassword
  macro included
    include Shield::SavePassword

    needs password_reset : PasswordReset

    before_save do
      validate_required password
    end

    after_save end_password_reset

    private def set_password_hash
      password.value.try do |value|
        password_hash.value = Login.hash_bcrypt(value)
      end
    end

    private def end_password_reset(user : User)
      EndPasswordReset.update!(password_reset)
    end
  end
end
