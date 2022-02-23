require "../../../spec_helper"

describe Shield::Api::BearerLoginHelpers do
  describe "#current_bearer" do
    it "return current token bearer" do
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

        response.should send_json(200, current_bearer: user.id)
      end
    end
  end
end
