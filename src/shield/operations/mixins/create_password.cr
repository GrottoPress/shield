module Shield::CreatePassword
  macro included
    before_save do
      set_password_digest
      validate_password_required
    end

    include Shield::ValidatePassword

    private def validate_password_required
      validate_required password,
        message: Rex.t(:"operation.error.password_required")
    end

    private def set_password_digest
      password.value.try do |value|
        password_digest.value = BcryptHash.new(value).hash
      end
    end
  end
end
