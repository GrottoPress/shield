module Shield::HttpClient
  macro included
    def api_auth(
      user : Shield::User,
      password : String,
      remote_ip = Socket::IPAddress.new("1.2.3.4", 5),
    )
      api_auth(user.email, password, remote_ip)
    end

    def api_auth(
      email : String,
      password : String,
      remote_ip = Socket::IPAddress.new("1.2.3.4", 5)
    )
      create_user(email, password)

      StartCurrentLogin.create(
        params(email: email, password: password),
        remote_ip: remote_ip,
        session: nil
      ) do |operation, login|
        login.try do |login|
          api_auth LoginCredentials.new(operation, login)
        end
      end

      self
    end

    def api_auth(token : String)
      LoginCredentials.from_token?(token).try do |credentials|
        api_auth(credentials)
      end
    end

    def api_auth(credentials : Shield::BearerCredentials)
      credentials.authenticate(client)
    end

    def basic_auth(credentials : Shield::BasicCredentials)
      credentials.authenticate(client)
    end

    def browser_auth(
      user : Shield::User,
      password : String,
      remote_ip = Socket::IPAddress.new("1.2.3.4", 5),
      session = Lucky::Session.new
    )
      browser_auth(user.email, password, remote_ip, session)
    end

    def browser_auth(
      email : String,
      password : String,
      remote_ip = Socket::IPAddress.new("1.2.3.4", 5),
      session = Lucky::Session.new
    )
      create_user(email, password)

      StartCurrentLogin.create!(
        params(email: email, password: password),
        session: session,
        remote_ip: remote_ip
      )

      set_cookie_from_session(session)
      self
    end

    def set_cookie_from_session(session : Lucky::Session)
      headers("Cookie": self.class.cookie_from_session?(session).to_s)
    end

    def self.cookie_from_session(session : Lucky::Session)
      cookie_from_session?(session).not_nil!
    end

    def self.cookie_from_session?(session : Lucky::Session)
      cookies = Lucky::CookieJar.empty_jar
      cookies.set(Lucky::Session.settings.key, session.to_json)
      cookies.updated.add_response_headers(HTTP::Headers.new)["Set-Cookie"]?
    end

    def self.session_from_cookies(cookies : HTTP::Cookies)
      cookies = Lucky::CookieJar.from_request_cookies(cookies)
      Lucky::Session.from_cookie_jar(cookies)
    end

    private def create_user(email, password) : Nil
      return if UserQuery.new.email(email).any?

      password_digest = BcryptHash.new(password).hash
      user = UserFactory.create &.email(email).password_digest(password_digest)

      {% if Avram::Model.all_subclasses.find(&.name.== :UserOptions.id) %}
        UserOptionsFactory.create &.user_id(user.id)
      {% end %}
    end
  end
end
