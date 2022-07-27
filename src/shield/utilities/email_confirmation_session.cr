module Shield::EmailConfirmationSession
  macro included
    include Shield::Session
    include Shield::EmailConfirmationVerifier

    def email_confirmation_id? : Int64?
      @session.get?(:email_confirmation_id).try &.to_i64?
    end

    def email_confirmation_token? : String?
      @session.get?(:email_confirmation_token)
    end

    def delete(email_confirmation : Shield::EmailConfirmation) : self
      delete if email_confirmation.id == email_confirmation_id?
      self
    end

    def delete : self
      @session.delete(:email_confirmation_id)
      @session.delete(:email_confirmation_token)
      self
    end

    def set(
      operation : Shield::StartEmailConfirmation,
      email_confirmation : Shield::EmailConfirmation
    ) : self
      set(operation.token, email_confirmation.id)
    end

    def set(token : String) : self
      BearerToken.from_token?(token).try do |bearer_token|
        set(bearer_token.password, bearer_token.id)
      end

      self
    end

    def set(token : String, id : Number) : self
      @session.set(:email_confirmation_id, id.to_s)
      @session.set(:email_confirmation_token, token)
      self
    end
  end
end
