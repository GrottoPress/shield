module Shield::CreatePassword
  macro included
    before_save do
      validate_required password

      set_password_digest
    end

    include Shield::ValidatePassword

    private def set_password_digest
      password.value.try do |value|
        password_digest.value = BcryptHash.new(value).hash
      end
    end
  end
end
