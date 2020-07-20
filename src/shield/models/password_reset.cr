module Shield::PasswordReset
  macro included
    skip_default_columns

    belongs_to user : User

    primary_key id : Int64

    column token_hash : String
    column ip_address : Socket::IPAddress?
    column started_at : Time
    column ended_at : Time?

    def active? : Bool
      ended_at.nil? || ended_at.not_nil! > Time.utc
    end

    def inactive? : Bool
      !active?
    end

    def url(token : String) : String
      PasswordResets::Show.url(id: id, token: token)
    end

    def self.from_session!(session : Lucky::Session, *, delete = false) : self?
      from_session(session, delete: delete).not_nil!
    end

    def self.from_session(session : Lucky::Session, *, delete = false) : self?
      session.get?(:password_reset).try do |id|
        return unless token = session.get?(:password_reset_token)

        session.delete(:password_reset) if delete
        session.delete(:password_reset_token) if delete
        authenticate(id, token.to_s)
      end
    end

    def self.set_session(session : Lucky::Session, params : Lucky::Params) : Nil
      params.get?(:id).try { |id| session.set(:password_reset, id) }
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
      return false unless active?
      return !EndPasswordReset.update!(self) if expired?
      Login.verify_sha256?(token, token_hash)
    rescue
      false
    end

    def expired? : Bool
      (Time.utc - started_at) > Shield.settings.password_reset_expiry
    end
  end
end
