module Shield::PasswordResetVerifier
  macro included
    include Shield::Verifier

    def verify : PasswordReset?
      return hash unless password_reset.try &.status.started?
      expire && return hash if expired?
      password_reset if verify?
    end

    def verify? : Bool?
      return unless password_reset && password_reset_token

      CryptoHelper.verify_sha256?(
        password_reset_token!,
        password_reset!.token_digest
      )
    end

    # To mitigate timing attacks
    private def hash : Nil
      password_reset_token.try { |token| CryptoHelper.hash_sha256(token) }
    end

    private def expire
      EndPasswordReset.update!(
        password_reset!,
        status: PasswordReset::Status.new(:expired)
      )
    rescue
      true
    end

    def expired? : Bool?
      password_reset.try do |password_reset|
        PasswordResetHelper.password_reset_expired?(password_reset)
      end
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
