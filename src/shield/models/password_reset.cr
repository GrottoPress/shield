module Shield::PasswordReset
  macro included
    include Shield::AuthenticationColumns(PasswordReset)

    def url(token : String) : String
      PasswordResets::Show.url(id: id, token: token)
    end

    def self.from_session!(session : Lucky::Session, *, delete = false) : self?
      from_session(session, delete: delete).not_nil!
    end

    def self.from_session(session : Lucky::Session, *, delete = false) : self?
      session.get?(:password_reset_id).try do |id|
        return unless token = session.get?(:password_reset_token)

        session.delete(:password_reset_id) if delete
        session.delete(:password_reset_token) if delete
        authenticate(id, token.to_s)
      end
    end

    def self.set_session(session : Lucky::Session, params : Lucky::Params) : Nil
      params.get?(:id).try { |id| session.set(:password_reset_id, id) }
      params.get?(:token).try do |token|
        session.set(:password_reset_token, token)
      end
    end

    def self.authenticate(id, token : String) : self?
      PasswordResetQuery.new.id(id.to_i64).first?.try do |password_reset|
        password_reset if password_reset.authenticate?(token)
      end
    end

    def authenticate?(token : String) : Bool
      return false unless status.started?
      return !EndPasswordReset.update!(
        self,
        status: Status.new(:expired)
      ) if expired?

      Login.verify_sha256?(token, token_hash)
    rescue
      false
    end

    def expired? : Bool
      (Time.utc - started_at) > Shield.settings.password_reset_expiry
    end
  end
end
