module Shield::CreatePassword
  macro included
    include Shield::ValidatePassword

    before_save do
      validate_required password

      set_password_digest
    end

    private def set_password_digest
      password.value.try do |value|
        password_digest.value = CryptoHelper.hash_bcrypt(value)
      end
    end
  end
end
