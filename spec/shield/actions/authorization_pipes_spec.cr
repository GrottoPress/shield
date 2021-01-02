require "../../spec_helper"

describe Shield::AuthorizationPipes do
  describe "#check_authorization" do
    it "denies authorization" do
      password = "password_1Apassword"

      user = UserBox.create &.level(User::Level.new(:author))
        .password_digest(BcryptHash.new(password).hash)

      client = ApiClient.new
      client.browser_auth(user, password)

      response = client.exec(Posts::New)

      response.status.should eq(HTTP::Status::FOUND)
      response.headers["X-Authorized"]?.should eq("false")
    end

    it "grants authorization" do
      password = "password_1Apassword"

      user = UserBox.create &.level(User::Level.new(:admin))
        .password_digest(BcryptHash.new(password).hash)

      client = ApiClient.new
      client.browser_auth(user, password)

      response = client.exec(Posts::New)

      response.should send_json(200, action: "Posts::New")
    end
  end
end
