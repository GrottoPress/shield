require "../../spec_helper"

describe Shield::LoginPipes do
  describe "#require_logged_in" do
    it "requires logged in" do
      response = ApiClient.exec(CurrentLogin::Destroy)

      response.status.should eq(HTTP::Status::FOUND)
      response.headers["X-Logged-In"]?.should eq("false")
    end
  end

  describe "#require_logged_out" do
    it "requires logged out" do
      email = "user@example.tld"
      password = "password4APASSWORD<"
      ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

      client = ApiClient.new
      client.browser_auth(email, password, ip_address)

      response = client.exec(CurrentLogin::Create)

      response.status.should eq(HTTP::Status::FOUND)
      response.headers["X-Logged-In"]?.should eq("true")
    end
  end

  describe "#pin_login_to_ip_address" do
    it "accepts login from same IP" do
      email = "user@eXAmple.tld"
      password = "password4APASSWORD<"
      ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

      user = UserFactory.create &.email(email).level(:admin).password(password)
      UserOptionsFactory.create &.user_id(user.id)

      client = ApiClient.new
      client.browser_auth(user, password, ip_address)

      response = client.exec(Users::Show.with(user_id: user.id))

      response.body.should eq("Users::ShowPage")
    end

    it "rejects login from different IP" do
      email = "usEr@ex4mple.tld"
      password = "password4APASSWORD<"

      user = UserFactory.create &.email(email).level(:admin).password(password)
      UserOptionsFactory.create &.user_id(user.id)

      client = ApiClient.new
      client.browser_auth(user, password)

      response = client.exec(Users::Edit.with(user_id: user.id))

      response.status.should eq(HTTP::Status::FOUND)
      response.headers["X-Ip-Address-Changed"]?.should eq("true")
    end
  end

  describe "#enforce_login_idle_timeout" do
    it "accepts login that has not timed out" do
      email = "user@example.tld"
      password = "password4APASSWORD<"
      ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

      user = UserFactory.create &.email(email).level(:admin).password(password)
      UserOptionsFactory.create &.user_id(user.id)

      session = Lucky::Session.new
      LoginIdleTimeoutSession.new(session).set

      client = ApiClient.new
      client.browser_auth(user, password, ip_address, session)

      response = client.exec(Users::Show.with(user_id: user.id))

      response.body.should eq("Users::ShowPage")
    end

    it "rejects login that has timed out" do
      Shield.temp_config(login_idle_timeout: 2.seconds) do
        email = "user@example.tld"
        password = "password4APASSWORD<"
        ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

        user = UserFactory.create &.email(email)
          .level(:admin)
          .password(password)

        UserOptionsFactory.create &.user_id(user.id)

        session = Lucky::Session.new
        LoginIdleTimeoutSession.new(session).set

        client = ApiClient.new
        client.browser_auth(user, password, ip_address, session)

        sleep 3.seconds

        response = client.exec(Users::Show.with(user_id: user.id))

        response.status.should eq(HTTP::Status::FOUND)
        response.headers["X-Login-Timed-Out"]?.should eq("true")
      end
    end

    it "refreshes last active time on every visit" do
      Shield.temp_config(login_idle_timeout: 3.seconds) do
        email = "user@example.tld"
        password = "password4APASSWORD<"
        ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

        user = UserFactory.create &.email(email)
          .level(:admin)
          .password(password)

        UserOptionsFactory.create &.user_id(user.id)

        session = Lucky::Session.new
        LoginIdleTimeoutSession.new(session).set

        client = ApiClient.new
        client.browser_auth(user, password, ip_address, session)

        response = client.exec(Users::Show.with(user_id: user.id))

        sleep 1.second

        client.headers("Cookie": response.headers["Set-Cookie"])
        response = client.exec(Users::Show.with(user_id: user.id))

        sleep 1.second

        client.headers("Cookie": response.headers["Set-Cookie"])
        response = client.exec(Users::Show.with(user_id: user.id))

        sleep 1.second

        client.headers("Cookie": response.headers["Set-Cookie"])
        response = client.exec(Users::Show.with(user_id: user.id))

        sleep 1.second

        client.headers("Cookie": response.headers["Set-Cookie"])
        response = client.exec(Users::Show.with(user_id: user.id))

        sleep 1.second

        client.headers("Cookie": response.headers["Set-Cookie"])
        response = client.exec(Users::Show.with(user_id: user.id))

        response.body.should eq("Users::ShowPage")
      end
    end

    it "is skipped when logged out" do
      response = ApiClient.exec(CurrentLogin::New)

      response.body.should eq("CurrentLogin::NewPage")
    end
  end

  describe "#check_authorization" do
    it "denies authorization" do
      password = "password_1Apassword"

      user = UserFactory.create &.level(:author).password(password)
      UserOptionsFactory.create &.user_id(user.id)

      client = ApiClient.new
      client.browser_auth(user, password)

      response = client.exec(Posts::New)

      response.status.should eq(HTTP::Status::FOUND)
      response.headers["X-Authorized"]?.should eq("false")
    end

    it "grants authorization" do
      password = "password_1Apassword"

      user = UserFactory.create &.level(:admin).password(password)
      UserOptionsFactory.create &.user_id(user.id)

      client = ApiClient.new
      client.browser_auth(user, password)

      response = client.exec(Posts::New)

      response.should send_json(200, action: "Posts::New")
    end
  end
end
