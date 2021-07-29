module Shield::PasswordResetVerifier
  macro included
    include Shield::Verifier

    def verify : PasswordReset?
      password_reset? if verify?
    end

    def verify? : Bool?
      return unless password_reset_id? && password_reset_token?
      sha256 = Sha256Hash.new(password_reset_token)

      if password_reset?.try(&.active?)
        sha256.verify?(password_reset.token_digest)
      else
        sha256.fake_verify
      end
    end

    def password_reset
      password_reset?.not_nil!
    end

    getter? password_reset : PasswordReset? do
      password_reset_id?.try { |id| PasswordResetQuery.new.id(id).first? }
    end

    def password_reset_id : Int64
      password_reset_id?.not_nil!
    end

    def password_reset_token : String
      password_reset_token?.not_nil!
    end
  end
end
