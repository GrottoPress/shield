require "../../../spec_helper"

describe Shield::Api::LoginPipes do
  describe "#require_logged_in" do
    it "allows logins" do
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
  end

  describe "#require_logged_out" do
    it "rejects logins" do
      email = "user@example.tld"
      password = "password4APASSWORD<"
      ip_address = Socket::IPAddress.new("129.0.0.5", 5555)

      client = ApiClient.new
      client.api_auth(email, password, ip_address)

      response = client.exec(Api::Posts::New)

      response.should send_json(200, logged_in: true)
    end
  end

  describe "#pin_login_to_ip_address" do
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

  describe "#check_authorization" do
    it "denies authorization" do
      password = "password_1Apassword"

      user = UserFactory.create &.password(password)
      UserOptionsFactory.create &.user_id(user.id)

      client = ApiClient.new
      client.api_auth(user, password)

      response = client.exec(Api::Posts::Create)

      response.should send_json(403, authorized: false)
    end

    it "grants authorization" do
      password = "password_1Apassword"

      user = UserFactory.create &.level(:admin).password(password)
      UserOptionsFactory.create &.user_id(user.id)

      client = ApiClient.new
      client.api_auth(user, password)

      response = client.exec(Api::Posts::Create)

      response.should send_json(200, current_user: user.id)
    end
  end
end
