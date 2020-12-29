module Shield::PasswordResetSession
  macro included
    include Shield::Session
    include Shield::PasswordResetVerifier

    def password_reset_id : Int64?
      @session.get?(:password_reset_id).try &.to_i64
    rescue
    end

    def password_reset_token : String?
      @session.get?(:password_reset_token)
    end

    def delete : self
      @session.delete(:password_reset_id)
      @session.delete(:password_reset_token)
      self
    end

    def set(
      password_reset : PasswordReset,
      operation : StartPasswordReset
    ) : self
      set(password_reset.id, operation.token)
    end

    def set(token : String) : self
      bearer_token = BearerToken.new(token)
      set(bearer_token.id, bearer_token.token)
    end

    def set(id, token : String) : self
      @session.set(:password_reset_id, id.to_s)
      @session.set(:password_reset_token, token)
      self
    end
  end
end
