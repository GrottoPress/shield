module Shield::Login
  macro included
    skip_default_columns

    avram_enum Status do
      Inactive
      Active
    end

    belongs_to user : User

    primary_key id : Int64

    column status : Login::Status
    column ip_address : Socket::IPAddress?
    column started_at : Time
    column ended_at : Time?

    def self.authenticate(email : String, password : String) : User?
      return unless user = User.from_email(email)
      return unless user.authenticate?(password)
      user
    end

    def self.from_session!(session : Lucky::Session) : self
      from_session(session).not_nil!
    end

    def self.from_session(session : Lucky::Session) : self?
      session.get?(:login).try { |id| LoginQuery.find(id.to_i64) }
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

    def remember(cookies : Lucky::CookieJar, params : Avram::Paramable) : Nil
      if params.get?(:remember_login)
        cookies.set(:remember_login, id.to_s)

        cookies
          .get_raw(:remember_login)
          .expires(Shield.settings.login_expiry.from_now)
      end
    end

    def self.set_return_path(session : Lucky::Session, path : String) : Nil
      session.set(:return_path, path)
    end

    def self.return_path(session : Lucky::Session, *, delete = false) : String?
      session.get?(:return_path).try do |path|
        session.delete(:return_path) if delete
        path
      end
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
