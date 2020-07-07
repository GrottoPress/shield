module Shield::Login
  macro included
    skip_default_columns

    belongs_to user : User

    primary_key id : Int64

    column token : String
    column ip_address : Socket::IPAddress?
    column started_at : Time
    column ended_at : Time?

    def active? : Bool
      ended_at.nil? || ended_at.not_nil! > Time.utc
    end

    def inactive? : Bool
      !active?
    end

    def self.from_session!(session : Lucky::Session) : self
      from_session(session).not_nil!
    end

    def self.from_session(session : Lucky::Session) : self?
      session.get?(:login).try do |id|
        return unless token = session.get?(:login_token)

        authenticate(id.to_i64, token.to_s)
      end
    end

    def set_session(session : Lucky::Session) : Nil
      session.set(:login, id.to_s)
      session.set(:login_token, token)
    end

    def self.set_session(
      session : Lucky::Session,
      cookies : Lucky::CookieJar
    ) : Nil
      return if expired?(cookies)

      cookies.get?(:login).try { |id| session.set(:login, id) }
      cookies.get?(:login_token).try do |token|
        session.set(:login_token, token)
      end
    end

    def self.delete_session(
      session : Lucky::Session,
      cookies : Lucky::CookieJar? = nil
    ) : Nil
      session.delete(:login)
      session.delete(:login_token)

      delete_cookie(cookies.not_nil!) unless cookies.nil?
    end

    def self.delete_cookie(cookies : Lucky::CookieJar) : Nil
      cookies.delete(:login)
      cookies.delete(:login_token)
    end

    def remember(cookies : Lucky::CookieJar) : Nil
      cookies.set(:login, id.to_s).expires(
        Shield.settings.login_expiry.from_now
      )

      cookies.set(:login_token, token).expires(
        Shield.settings.login_expiry.from_now
      )
    end

    def self.expired?(cookies : Lucky::CookieJar) : Bool
      cookies.deleted?(:login) || cookies.deleted?(:login_token)
    end

    def expired? : Bool
      (Time.utc - started_at) > Shield.settings.login_expiry
    end

    def self.authenticate(id : Int64, token : String) : self?
      return unless login = LoginQuery.new.id(id).first?
      return unless login.authenticate?(token)
      login
    end

    def authenticate?(token : String) : Bool
      active? && self.token == token
    end

    def self.hash(plaintext : String) : Crypto::Bcrypt::Password
      Crypto::Bcrypt::Password.create(plaintext)
    end

    def self.verify?(plaintext : String, hash : String) : Bool
      Crypto::Bcrypt::Password.new(hash).verify(plaintext)
    rescue
      false
    end

    def self.generate_token(size : Int32 = 32) : String
      Random::Secure.urlsafe_base64(size)
    end
  end
end
