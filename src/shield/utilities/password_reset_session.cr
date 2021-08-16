module Shield::PasswordResetSession
  macro included
    include Shield::Session
    include Shield::PasswordResetVerifier

    def password_reset_id? : Int64?
      @session.get?(:password_reset_id).try &.to_i64?
    end

    def password_reset_token? : String?
      @session.get?(:password_reset_token)
    end

    def delete(password_reset : Shield::PasswordReset) : self
      delete if password_reset.id == password_reset_id?
      self
    end

    def delete : self
      @session.delete(:password_reset_id)
      @session.delete(:password_reset_token)
      self
    end

    def set(
      operation : Shield::StartPasswordReset,
      password_reset : Shield::PasswordReset
    ) : self
      set(operation.token, password_reset.id)
    end

    def set(token : String) : self
      bearer_token = BearerToken.new(token)
      set(bearer_token.token, bearer_token.id?)
    end

    def set(token : String, id) : self
      @session.set(:password_reset_id, id.to_s)
      @session.set(:password_reset_token, token)
      self
    end
  end
end
