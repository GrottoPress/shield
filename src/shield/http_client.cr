module Shield::HttpClient
  macro included
    def api_auth(token : String)
      headers("Authorization": "Bearer #{token}")
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
        bearer_header = LoginHelper.bearer_header(login.not_nil!, operation)
        headers("Authorization": bearer_header)
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

      cookies = Lucky::CookieJar.empty_jar

      LogUserIn.create!(
        params(email: email, password: password),
        session: session,
        remote_ip: remote_ip
      )

      cookies.set(Lucky::Session.settings.key, session.to_json)
      headers = cookies.updated.add_response_headers(HTTP::Headers.new)
      headers("Cookie": headers["Set-Cookie"]?.to_s)

      self
    end
  end
end
