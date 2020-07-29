module Shield::ResetPassword
  macro included
    include Shield::UpdatePassword

    attribute password : String
    attribute password_confirmation : String

    needs password_reset : PasswordReset

    before_save do
      validate_required password
    end

    after_save end_password_reset

    private def set_password_hash
      password.value.try do |value|
        password_hash.value = VerifyLogin.hash_bcrypt(value)
      end
    end

    private def end_password_reset(user : User)
      EndPasswordReset.update!(
        password_reset,
        status: PasswordReset::Status.new(:ended)
      )
    end
  end
end
