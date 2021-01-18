require "../../../spec_helper"

describe Shield::Api::LoginHelpers do
  describe "#current_login" do
    it "does not use session authentication" do
      email = "user@example.tld"
      password = "password4APASSWORD<"
      ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

      user = UserBox.create &.email(email).password(password)
      UserOptionsBox.create &.user_id(user.id)

      client = ApiClient.new

      client.browser_auth(user, password, ip_address)
      response = client.exec(Api::Posts::Index)

      response.status_code.should eq(401)

      client.api_auth(user, password, ip_address)
      response = client.exec(Api::Posts::Index)

      response.should send_json(200, current_user: user.id)
    end
  end

  describe "#current_bearer_user" do
    it "works" do
      email = "user@example.tld"
      password = "password4APASSWORD<"

      user = UserBox.create &.email(email).password(password)
      UserOptionsBox.create &.user_id(user.id)

      CreateBearerLogin.create(
        params(name: "secret token"),
        scopes: ["api.posts.index"],
        allowed_scopes: ["api.posts.update", "api.posts.index"],
        user_id: user.id
      ) do |operation, bearer_login|
        bearer_login = bearer_login.not_nil!

        token = BearerToken.new(operation, bearer_login)

        client = ApiClient.new
        client.api_auth(token)
        response = client.exec(Api::Posts::Index)

        response.should send_json(200, current_bearer_user: user.id)
      end
    end
  end
end
