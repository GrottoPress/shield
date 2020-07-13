module Shield::Login
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

    def self.from_session!(session : Lucky::Session) : self
      from_session(session).not_nil!
    end

    def self.from_session(session : Lucky::Session) : self?
      session.get?(:login).try do |id|
        return unless token = session.get?(:login_token)
        authenticate(id, token.to_s)
      end
    end

    def set_session(session : Lucky::Session, token : String) : Nil
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

    def set_cookie(cookies : Lucky::CookieJar, token : String) : Nil
      expiry = Shield.settings.login_expiry.from_now

      cookies.set(:login, id.to_s).expires(expiry)
      cookies.set(:login_token, token).expires(expiry)
    end

    def self.expired?(cookies : Lucky::CookieJar) : Bool
      cookies.deleted?(:login) || cookies.deleted?(:login_token)
    end

    def expired? : Bool
      (Time.utc - started_at) > Shield.settings.login_expiry
    end

    def self.authenticate(id, token : String) : self?
      LoginQuery.new.id(id.to_i64).first?.try do |login|
        login if login.authenticate?(token)
      end
    end

    def authenticate?(token : String) : Bool
      active? && self.class.verify_sha256?(token, token_hash)
    end

    def self.hash_bcrypt(plaintext : String) : String
      Crypto::Bcrypt::Password.create(plaintext).to_s
    end

    def self.verify_bcrypt?(plaintext : String, hash : String) : Bool
      Crypto::Bcrypt::Password.new(hash).verify(plaintext)
    rescue
      false
    end

    def self.hash_sha256(plaintext : String) : String
      digest = OpenSSL::Digest.new("SHA256")
      digest << plaintext
      digest.final.hexstring
    end

    def self.verify_sha256?(plaintext : String, hash : String) : Bool
      hash_sha256(plaintext) == hash
    end

    def self.generate_token(size : Int32 = 32) : String
      Random::Secure.urlsafe_base64(size)
    end
  end
end
