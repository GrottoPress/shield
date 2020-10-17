module Shield::PasswordResetSession
  macro included
    include Shield::Session
    include Shield::PasswordResetVerifier

    private def expire
      EndPasswordReset.update!(
        password_reset!,
        status: PasswordReset::Status.new(:expired),
        session: @session
      )
    rescue
      true
    end

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

    def set(token : String) : self
      id_token = token.split('.', 2)
      set(id_token[0]?, id_token[1]?.to_s)
    end

    def set(id, token : String) : self
      @session.set(:password_reset_id, id.to_s)
      @session.set(:password_reset_token, token)
      self
    end
  end
end
