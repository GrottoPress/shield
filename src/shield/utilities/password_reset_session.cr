module Shield::PasswordResetSession
  macro included
    def initialize(@session : Lucky::Session)
    end

    def verify!
      verify.not_nil!
    end

    def verify
      yield self, verify
    end

    def verify : PasswordReset?
      return hash unless password_reset.try &.status.started?
      expire && return hash if expired?
      password_reset! if verify?
    rescue
    end

    def verify? : Bool?
      CryptoHelper.verify_sha256?(
        password_reset_token!,
        password_reset!.token_hash
      )
    rescue NilAssertionError
    end

    private def expire
      EndPasswordReset.update!(
        password_reset!,
        status: PasswordReset::Status.new(:expired),
        session: @session
      )
    rescue
      true
    end

    # To mitigate timing attacks
    private def hash : Nil
      CryptoHelper.hash_sha256(password_reset_token!)
    rescue
    end

    def expired? : Bool?
      PasswordResetHelper.password_reset_expired?(password_reset!)
    rescue NilAssertionError
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

    def password_reset_id : Int64?
      @session.get?(:password_reset_id).try { |id| id.to_i64 }
    end

    def password_reset_token : String?
      @session.get?(:password_reset_token)
    end

    def delete : self
      @session.delete(:password_reset_id)
      @session.delete(:password_reset_token)
      self
    end

    def set(id, token : String) : self
      @session.set(:password_reset_id, id.to_s)
      @session.set(:password_reset_token, token)
      self
    end
  end
end
