module Shield::SetPasswordDigestFromPassword
  macro included
    before_save do
      set_password_digest
    end

    private def set_password_digest
      password.value.try do |value|
        password_digest.value = BcryptHash.new(value).hash
      end
    end
  end
end
