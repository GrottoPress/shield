module Shield::CreatePassword
  macro included
    include Shield::ValidatePassword

    before_save do
      validate_required password

      set_password_hash
    end

    private def set_password_hash
      if value = password.value
        password_hash.value = VerifyLogin.hash_bcrypt(value.not_nil!)
      else
        # So that *Avram*'s `validate_required password_hash` passes.
        # We've already taken care of required password with
        # `validate_required password`
        #
        # We do not want to confuse the user with "password_hash
        # is required", do we?
        password_hash.value = "TydNxfeGxekb5B7U-hC2TpF6U4EEEVrQ5"
      end
    end
  end
end
