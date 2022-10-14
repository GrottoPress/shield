require "../../../spec_helper"

describe Shield::Api::BearerLoginHelpers do
  describe "#current_bearer" do
    it "return current bearer" do
      email = "user@example.tld"
      password = "password4APASSWORD<"

      user = UserFactory.create &.email(email).password(password)
      UserOptionsFactory.create &.user_id(user.id)

      CreateBearerLogin.create(
        params(
          name: "secret token",
          scopes: [BearerScope.new(Api::Posts::Index).to_s]
        ),
        user: user
      ) do |operation, bearer_login|
        bearer_login = bearer_login.not_nil!

        token = BearerLoginCredentials.new(operation, bearer_login)

        client = ApiClient.new
        client.api_auth(token)
        response = client.exec(Api::Posts::Index)

        response.should send_json(200, current_bearer: user.id)
      end
    end
  end
end
