module Shield::EmailConfirmationSession
  macro included
    include Shield::Session
    include Shield::EmailConfirmationVerifier

    def email_confirmation_id : Int64?
      @session.get?(:email_confirmation_id).try &.to_i64
    rescue
    end

    def email_confirmation_token : String?
      @session.get?(:email_confirmation_token)
    end

    def delete : self
      @session.delete(:email_confirmation_id)
      @session.delete(:email_confirmation_token)
      self
    end

    def set(
      email_confirmation : EmailConfirmation,
      operation : StartEmailConfirmation
    ) : self
      set(email_confirmation.id, operation.token)
    end

    def set(token : String) : self
      bearer_token = BearerToken.new(token)
      set(bearer_token.id, bearer_token.token)
    end

    def set(id, token : String) : self
      @session.set(:email_confirmation_id, id.to_s)
      @session.set(:email_confirmation_token, token)
      self
    end
  end
end
