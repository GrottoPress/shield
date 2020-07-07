module Shield::PasswordReset
  macro included
    belongs_to user : User

    column ip_address : Socket::IPAddress?
    column token_hash : String?

    def url(token : String) : String
      PasswordResets::Index.url(id: id, token: token)
    end

    def self.from_session!(
      session : Lucky::Session,
      *,
      delete = false,
      preload_user = false
    ) : self?
      from_session(session, delete: delete, preload_user: preload_user).not_nil!
    end

    def self.from_session(
      session : Lucky::Session,
      *,
      delete = false,
      preload_user = false
    ) : self?
      session.get?(:password_reset).try do |id|
        session.delete(:password_reset) if delete
        query = PasswordResetQuery.new
        query.preload_user if preload_user
        query.find(id.to_i64)
      end
    end

    def set_session(session : Lucky::Session) : Nil
      session.set(:password_reset, id.to_s)
    end

    def self.authenticate(id : Int64, token : String) : self?
      PasswordResetQuery.new.id(id).first?.try do |password_reset|
        password_reset if password_reset.authenticate?(token)
      end
    end

    def authenticate?(token : String) : Bool
      !token_expired? && Login.verify?(token, token_hash.to_s)
    end

    def token_expired? : Bool
      token_hash.to_s.empty? ||
        (Time.utc - created_at >= Shield.settings.password_reset_token_expiry)
    end
  end
end
