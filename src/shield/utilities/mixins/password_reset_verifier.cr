module Shield::PasswordResetVerifier
  macro included
    include Shield::Verifier

    def verify : PasswordReset?
      return hash unless active?
      password_reset if verify?
    end

    def active? : Bool?
      password_reset.try &.active?
    end

    def verify? : Bool?
      return unless password_reset && password_reset_token

      Sha256Hash.new(password_reset_token!)
        .verify?(password_reset!.token_digest)
    end

    # To mitigate timing attacks
    private def hash : Nil
      password_reset_token.try { |token| Sha256Hash.new(token).hash }
    end

    def password_reset! : PasswordReset
      password_reset.not_nil!
    end

    @[Memoize]
    def password_reset : PasswordReset?
      password_reset_id.try { |id| PasswordResetQuery.new.id(id).first? }
    end

    def password_reset_id! : Int64
      password_reset_id.not_nil!
    end

    def password_reset_token! : String
      password_reset_token.not_nil!
    end
  end
end
