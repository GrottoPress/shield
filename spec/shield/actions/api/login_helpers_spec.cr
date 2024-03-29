require "../../../spec_helper"

describe Shield::Api::LoginHelpers do
  describe "#current_login" do
    it "does not use session authentication" do
      email = "user@example.tld"
      password = "password4APASSWORD<"
      ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

      user = UserFactory.create &.email(email).password(password)
      UserOptionsFactory.create &.user_id(user.id)

      client = ApiClient.new

      client.browser_auth(user, password, ip_address)
      response = client.exec(Api::Posts::Index)

      response.status_code.should eq(401)

      client.api_auth(user, password, ip_address)
      response = client.exec(Api::Posts::Index)

      response.should send_json(200, current_user: user.id)
    end
  end
end
