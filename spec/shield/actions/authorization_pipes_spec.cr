require "../../spec_helper"

describe Shield::AuthorizationPipes do
  describe "#check_authorization" do
    it "denies authorization" do
      password = "password_1Apassword"
      ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

      user = UserBox.create &.password_digest(
        CryptoHelper.hash_bcrypt(password)
      )

      client = ApiClient.new
      client.browser_auth(user, password, ip_address)

      response = client.exec(Users::Show.with(user_id: user.id))

      response.status.should eq(HTTP::Status::FOUND)
      response.headers["X-Authorized"]?.should eq("false")
    end

    it "grants authorization" do
      password = "password_1Apassword"
      ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

      user = UserBox.create &.level(User::Level.new(:admin))
        .password_digest(CryptoHelper.hash_bcrypt(password))

      client = ApiClient.new
      client.browser_auth(user, password, ip_address)

      response = client.exec(Users::Show.with(user_id: user.id))

      response.should send_json(200, user: user.id)
    end
  end
end
