module Shield::EmailConfirmationSession
  macro included
    include Shield::EmailConfirmationVerifier

    def initialize(@session : Lucky::Session)
    end

    def email_confirmation_id?
      @session.get?(:email_confirmation_id).try do |id|
        EmailConfirmation::PrimaryKeyType.adapter.parse(id).value
      end
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
      EmailConfirmationCredentials.from_token?(token).try do |credentials|
        set(credentials.password, credentials.id)
      end

      self
    end

    def set(token : String, id : EmailConfirmation::PrimaryKeyType) : self
      @session.set(:email_confirmation_id, id.to_s)
      @session.set(:email_confirmation_token, token)
      self
    end
  end
end
