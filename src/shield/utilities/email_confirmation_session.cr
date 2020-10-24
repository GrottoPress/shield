module Shield::EmailConfirmationSession
  macro included
    include Shield::Session
    include Shield::EmailConfirmationVerifier

    private def expire
      EndEmailConfirmation.update!(
        email_confirmation!,
        status: EmailConfirmation::Status.new(:expired),
        session: @session
      )
    rescue
      true
    end

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
      id_token = token.split('.', 2)
      set(id_token[0]?, id_token[1]?.to_s)
    end

    def set(id, token : String) : self
      @session.set(:email_confirmation_id, id.to_s)
      @session.set(:email_confirmation_token, token)
      self
    end
  end
end
