module Shield::PasswordReset
  macro included
    belongs_to user : User

    column ip_address : Socket::IPAddress?
    column token_hash : String?

    def url(token : String) : String
      "#{Shield.settings.base_uri}/password-resets?id=#{id}&token=#{token}"
    end

    def self.from_session!(session : Lucky::Session, *, delete = false) : self?
      from_session(session, delete: delete).not_nil!
    end

    def self.from_session(session : Lucky::Session, *, delete = false) : self?
      session.get?(:password_reset).try do |id|
        session.delete(:password_reset) if delete
        PasswordResetQuery.find(id.to_i64)
      end
    end

    def set_session(session : Lucky::Session) : Nil
      session.set(:password_reset, id.to_s)
    end

    def self.authenticate(id : Int64, token : String) : self?
      return unless reset = PasswordResetQuery.new.id(id).first?
      return unless reset.authenticate?(token)
      reset
    end

    def authenticate?(token : String) : Bool
      !token_expired? && Login.verify?(token, token_hash.to_s)
    end

    def token_expired? : Bool
      token_hash.to_s.empty? ||
        (Time.utc - created_at >= Shield.settings.reset_token_expiry)
    end
  end
end
