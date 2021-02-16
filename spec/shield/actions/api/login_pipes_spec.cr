require "../../../spec_helper"

describe Shield::Api::LoginPipes do
  describe "#require_logged_in" do
    it "allows logins with regular passwords" do
      email = "user@example.tld"
      password = "password4APASSWORD<"
      ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

      user = UserFactory.create &.email(email).password(password)
      UserOptionsFactory.create &.user_id(user.id)

      client = ApiClient.new
      client.api_auth(user, password, ip_address)

      response = client.exec(Api::Posts::Index)

      response.should send_json(200, current_user: user.id)
    end

    it "allows logins with user-generated bearer tokens" do
      email = "user@example.tld"
      password = "password4APASSWORD<"

      user = UserFactory.create &.email(email).password(password)
      UserOptionsFactory.create &.user_id(user.id)

      CreateBearerLogin.create(
        params(name: "secret token"),
        scopes: ["api.posts.index"],
        allowed_scopes: ["api.posts.update", "api.posts.index"],
        user: user
      ) do |operation, bearer_login|
        bearer_login = bearer_login.not_nil!

        token = BearerToken.new(operation, bearer_login)

        client = ApiClient.new
        client.api_auth(token)
        response = client.exec(Api::Posts::Index)

        response.should send_json(200, current_bearer_user: user.id)
      end
    end

    it "requires logged in" do
      response = ApiClient.exec(Api::Posts::Index)

      response.headers["WWW-Authenticate"]?.should_not be_nil
      response.should send_json(401, logged_in: false)
    end
  end

  describe "#require_logged_out" do
    it "rejects logins with regular passwords" do
      email = "user@example.tld"
      password = "password4APASSWORD<"
      ip_address = Socket::IPAddress.new("129.0.0.5", 5555)

      client = ApiClient.new
      client.api_auth(email, password, ip_address)

      response = client.exec(Api::Posts::New)

      response.should send_json(200, logged_in: true)
    end

    it "rejects logins with user-generated bearer tokens" do
      email = "user@example.tld"
      password = "password4APASSWORD<"

      user = UserFactory.create &.email(email).password(password)
      UserOptionsFactory.create &.user_id(user.id)

      CreateBearerLogin.create(
        params(name: "secret token"),
        scopes: ["api.posts.new"],
        allowed_scopes: ["api.posts.new", "api.posts.index"],
        user: user
      ) do |operation, bearer_login|
        bearer_login = bearer_login.not_nil!

        token = BearerToken.new(operation, bearer_login)

        client = ApiClient.new
        client.api_auth(token)
        response = client.exec(Api::Posts::New)

        response.should send_json(200, logged_in: true)
      end
    end
  end

  describe "#pin_login_to_ip_address" do
    context "for logins with regular passwords" do
      it "accepts login from same IP" do
        email = "user@example.tld"
        password = "password4APASSWORD<"
        ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

        user = UserFactory.create &.email(email)
          .level(:admin)
          .password(password)

        UserOptionsFactory.create &.user_id(user.id)

        client = ApiClient.new
        client.api_auth(user, password, ip_address)

        response = client.exec(Api::Posts::Index)

        response.should send_json(200, current_user: user.id)
      end

      it "rejects login from different IP" do
        email = "user@example.tld"
        password = "password4APASSWORD<"

        user = UserFactory.create &.email(email)
          .level(:admin)
          .password(password)

        UserOptionsFactory.create &.user_id(user.id)

        client = ApiClient.new
        client.api_auth(user, password)

        response = client.exec(Api::Posts::Index)

        response.should send_json(403, ip_address_changed: true)
      end
    end
  end
end
