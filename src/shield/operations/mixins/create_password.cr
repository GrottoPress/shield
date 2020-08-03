module Shield::CreatePassword
  macro included
    include Shield::ValidatePassword

    before_save do
      validate_required password

      set_password_hash
    end

    private def set_password_hash
      password.value.try do |value|
        password_hash.value = VerifyLogin.hash_bcrypt(value)
      end
    end
  end
end
