module Shield::PasswordResetSession
  macro included
    include Shield::PasswordResetVerifier

    def initialize(@session : Lucky::Session)
    end

    def self.new(context : HTTP::Server::Context)
      new(context.session)
    end

    def password_reset_id?
      @session.get?(:password_reset_id).try do |id|
        PasswordReset::PrimaryKeyType.adapter.parse(id).value
      end
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
      PasswordResetCredentials.from_token?(token).try do |credentials|
        set(credentials.password, credentials.id)
      end

      self
    end

    def set(token : String, id : PasswordReset::PrimaryKeyType) : self
      @session.set(:password_reset_id, id.to_s)
      @session.set(:password_reset_token, token)
      self
    end
  end
end
