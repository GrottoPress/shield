module Shield::Login
  macro included
    skip_default_columns

    belongs_to user : User

    primary_key id : Int64

    column ip_address : Socket::IPAddress?
    column started_at : Time
    column ended_at : Time?

    def active? : Bool
      ended_at.nil? || ended_at.not_nil! > Time.utc
    end

    def inactive? : Bool
      !active?
    end

    def self.authenticate(email : String, password : String) : User?
      return unless user = User.from_email(email)
      return unless user.authenticate?(password)
      user
    end

    def self.from_session!(
      session : Lucky::Session,
      *,
      preload_user = false
    ) : self
      from_session(session, preload_user: preload_user).not_nil!
    end

    def self.from_session(
      session : Lucky::Session,
      *,
      preload_user = false
    ) : self?
      session.get?(:login).try do |id|
        query = LoginQuery.new
        query.preload_user if preload_user
        query.find(id.to_i64)
      end
    end

    def set_session(session : Lucky::Session) : Nil
      session.set(:login, id.to_s)
    end

    def self.set_session(
      session : Lucky::Session,
      cookies : Lucky::CookieJar
    ) : Nil
      cookies.get?(:remember_login).try { |id| session.set(:login, id) }
    end

    def self.delete_session(
      session : Lucky::Session,
      cookies : Lucky::CookieJar
    ) : Nil
      session.delete(:login)
      cookies.delete(:remember_login)
    end

    def remember(cookies : Lucky::CookieJar) : Nil
      cookies.set(:remember_login, id.to_s).expires(
        Shield.settings.login_expiry.from_now
      )
    end

    def self.hash(plaintext : String) : Crypto::Bcrypt::Password
      Crypto::Bcrypt::Password.create(plaintext)
    end

    def self.verify?(plaintext : String, hash : String) : Bool
      Crypto::Bcrypt::Password.new(hash).verify(plaintext)
    rescue
      false
    end
  end
end
