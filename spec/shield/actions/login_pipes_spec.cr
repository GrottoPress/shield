require "../../spec_helper"

describe Shield::LoginPipes do
  describe "#require_logged_in" do
    it "requires logged in" do
      response = ApiClient.exec(CurrentLogin::Destroy)

      response.status.should eq(HTTP::Status::FOUND)
      response.headers["X-Logged-In"].should eq("false")
    end
  end

  describe "#require_logged_out" do
    it "requires logged out" do
      email = "user@example.tld"
      password = "password4APASSWORD<"

      UserBox.create &.email(email)
        .password_digest(CryptoHelper.hash_bcrypt(password))

      client = ApiClient.new

      response = client.exec(CurrentLogin::Create, login: {
        email: email,
        password: password
      })

      response.status.should eq(HTTP::Status::FOUND)

      client.headers("Cookie": response.headers["Set-Cookie"])
      response = client.exec(CurrentLogin::Create)

      response.status.should eq(HTTP::Status::FOUND)
      response.headers["X-Logged-In"].should eq("true")
    end
  end

  describe "#pin_login_to_ip_address" do
    it "accepts login from same IP" do
      email = "user@example.tld"
      password = "password4APASSWORD<"

      user = UserBox.create &.email(email)
        .level(User::Level.new :admin)
        .password_digest(CryptoHelper.hash_bcrypt(password))

      client = ApiClient.new

      response = client.exec(CurrentLogin::Create, login: {
        email: email,
        password: password
      })

      response.status.should eq(HTTP::Status::FOUND)

      client.headers("Cookie": response.headers["Set-Cookie"])
      response = client.exec(Users::Show.with(user_id: user.id))

      response.should send_json(200, user: user.id)
    end

    it "rejects login from different IP" do
      email = "user@example.tld"
      password = "password4APASSWORD<"

      user = UserBox.create &.email(email)
        .level(User::Level.new :admin)
        .password_digest(CryptoHelper.hash_bcrypt(password))

      client = ApiClient.new

      response = client.exec(CurrentLogin::Create, login: {
        email: email,
        password: password
      })

      response.status.should eq(HTTP::Status::FOUND)

      client.headers("Cookie": response.headers["Set-Cookie"])
      response = client.exec(Users::Edit.with(user_id: user.id))

      response.status.should eq(HTTP::Status::FOUND)
      response.headers["X-Ip-Address-Changed"].should eq("true")
    end
  end

  describe "#enforce_login_idle_timeout" do
    it "accepts login that has not timed out" do
      email = "user@example.tld"
      password = "password4APASSWORD<"

      user = UserBox.create &.email(email)
        .level(User::Level.new :admin)
        .password_digest(CryptoHelper.hash_bcrypt(password))

      cookies = Lucky::CookieJar.empty_jar
      session = Lucky::Session.new

      LogUserIn.create!(
        params(email: email, password: password),
        session: session,
        remote_ip: Socket::IPAddress.new("128.0.0.2", 5000)
      )

      cookies.set(Lucky::Session.settings.key, session.to_json)
      headers = cookies.updated.add_response_headers(HTTP::Headers.new)

      client = ApiClient.new

      client.headers("Cookie": headers["Set-Cookie"])
      response = client.exec(Users::Show.with(user_id: user.id))

      response.should send_json(200, user: user.id)
    end

    it "rejects login that has timed out" do
      Shield.temp_config(login_idle_timeout: 2.seconds) do
        email = "user@example.tld"
        password = "password4APASSWORD<"

        user = UserBox.create &.email(email)
          .level(User::Level.new :admin)
          .password_digest(CryptoHelper.hash_bcrypt(password))

        cookies = Lucky::CookieJar.empty_jar
        session = Lucky::Session.new

        LogUserIn.create!(
          params(email: email, password: password),
          session: session,
          remote_ip: Socket::IPAddress.new("128.0.0.2", 5000)
        )

        cookies.set(Lucky::Session.settings.key, session.to_json)
        headers = cookies.updated.add_response_headers(HTTP::Headers.new)

        client = ApiClient.new

        sleep 3

        client.headers("Cookie": headers["Set-Cookie"])
        response = client.exec(Users::Show.with(user_id: user.id))

        response.status.should eq(HTTP::Status::FOUND)
        response.headers["Location"].should eq(CurrentLogin::New.path)
      end
    end

    it "refreshes last active time on every visit" do
      Shield.temp_config(login_idle_timeout: 3.seconds) do
        email = "user@example.tld"
        password = "password4APASSWORD<"

        user = UserBox.create &.email(email)
          .level(User::Level.new :admin)
          .password_digest(CryptoHelper.hash_bcrypt(password))

        cookies = Lucky::CookieJar.empty_jar
        session = Lucky::Session.new

        LogUserIn.create!(
          params(email: email, password: password),
          session: session,
          remote_ip: Socket::IPAddress.new("128.0.0.2", 5000)
        )

        cookies.set(Lucky::Session.settings.key, session.to_json)
        headers = cookies.updated.add_response_headers(HTTP::Headers.new)

        client = ApiClient.new

        client.headers("Cookie": headers["Set-Cookie"])
        response = client.exec(Users::Show.with(user_id: user.id))

        sleep 1

        client.headers("Cookie": response.headers["Set-Cookie"])
        response = client.exec(Users::Show.with(user_id: user.id))

        sleep 1

        client.headers("Cookie": response.headers["Set-Cookie"])
        response = client.exec(Users::Show.with(user_id: user.id))

        sleep 1

        client.headers("Cookie": response.headers["Set-Cookie"])
        response = client.exec(Users::Show.with(user_id: user.id))

        sleep 1

        client.headers("Cookie": response.headers["Set-Cookie"])
        response = client.exec(Users::Show.with(user_id: user.id))

        sleep 1

        client.headers("Cookie": response.headers["Set-Cookie"])
        response = client.exec(Users::Show.with(user_id: user.id))

        response.should send_json(200, user: user.id)
      end
    end

    it "is skipped when logged out" do
      response = ApiClient.exec(CurrentLogin::New)

      response.body.should eq("CurrentLogin::New")
    end
  end
end
