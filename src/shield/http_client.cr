module Shield::HttpClient
  macro included
    def api_auth(token : String)
      api_auth(BearerToken.new token)
    end

    def api_auth(token : BearerToken)
      headers("Authorization": token.to_header)
    end

    def api_auth(
      user : User,
      password : String,
      remote_ip = Socket::IPAddress.new("1.2.3.4", 5),
    )
      api_auth(user.email, password, remote_ip, create_user: false)
    end

    def api_auth(
      email : String,
      password : String,
      remote_ip = Socket::IPAddress.new("1.2.3.4", 5),
      *,
      create_user = true
    )
      if create_user
        UserBox.create &.email(email)
          .password_digest(CryptoHelper.hash_bcrypt(password))
      end

      LogUserIn.create(
        params(email: email, password: password),
        remote_ip: remote_ip
      ) do |operation, login|
        headers("Authorization": BearerToken.new(
          operation,
          login.not_nil!
        ).to_header)
      end

      self
    end

    def browser_auth(
      user : User,
      password : String,
      remote_ip = Socket::IPAddress.new("1.2.3.4", 5),
      session = Lucky::Session.new
    )
      browser_auth(user.email, password, remote_ip, session, create_user: false)
    end

    def browser_auth(
      email : String,
      password : String,
      remote_ip = Socket::IPAddress.new("1.2.3.4", 5),
      session = Lucky::Session.new,
      *,
      create_user = true
    )
      if create_user
        UserBox.create &.email(email)
          .password_digest(CryptoHelper.hash_bcrypt(password))
      end

      LogUserIn.create!(
        params(email: email, password: password),
        session: session,
        remote_ip: remote_ip
      )

      set_cookie_from_session(session)
      self
    end

    def set_cookie_from_session(session : Lucky::Session)
      headers("Cookie": self.class.cookie_from_session(session).to_s)
    end

    def self.cookie_from_session!(session : Lucky::Session)
      cookie_from_session(session).not_nil!
    end

    def self.cookie_from_session(session : Lucky::Session)
      cookies = Lucky::CookieJar.empty_jar
      cookies.set(Lucky::Session.settings.key, session.to_json)
      cookies.updated.add_response_headers(HTTP::Headers.new)["Set-Cookie"]?
    end
  end
end
