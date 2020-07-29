module Shield::SetPasswordHash
  macro included
    before_save do
      set_password_hash
    end

    private def set_password_hash
      password.value.try do |value|
        return if VerifyLogin.verify_bcrypt?(
          value,
          password_hash.original_value.to_s
        )

        password_hash.value = VerifyLogin.hash_bcrypt(value)
      end
    end
  end
end
