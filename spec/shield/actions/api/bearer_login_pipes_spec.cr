require "../../../spec_helper"

describe Shield::Api::BearerLoginPipes do
  describe "#require_logged_in" do
    it "allows logins" do
      email = "user@example.tld"
      password = "password4APASSWORD<"

      user = UserFactory.create &.email(email).password(password)
      UserOptionsFactory.create &.user_id(user.id)

      CreateBearerLogin.create(
        params(name: "secret token"),
        scopes: [BearerScope.new(Api::Posts::Index).to_s],
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

    it "requires logged in" do
      response = ApiClient.exec(Api::Posts::Index)

      response.headers["WWW-Authenticate"]?.should_not be_nil
      response.should send_json(401, logged_in: false)
    end

    it "rejects login when scopes insufficient" do
      user = UserFactory.create &.level(:admin)
      UserOptionsFactory.create &.user_id(user.id)

      CreateBearerLogin.create(
        params(name: "secret token"),
        scopes: [BearerScope.new(Api::Posts::Index).to_s],
        user: user
      ) do |operation, bearer_login|
        bearer_login = bearer_login.not_nil!

        token = BearerLoginCredentials.new(operation, bearer_login)

        client = ApiClient.new
        client.api_auth(token)

        response = client.exec(Api::Posts::Create)

        response.should send_json(403, logged_in: false)
      end
    end
  end

  describe "#require_logged_out" do
    it "rejects logins" do
      email = "user@example.tld"
      password = "password4APASSWORD<"

      user = UserFactory.create &.email(email).password(password)
      UserOptionsFactory.create &.user_id(user.id)

      CreateBearerLogin.create(
        params(name: "secret token"),
        scopes: [BearerScope.new(Api::Posts::New).to_s],
        user: user
      ) do |operation, bearer_login|
        bearer_login = bearer_login.not_nil!

        token = BearerLoginCredentials.new(operation, bearer_login)

        client = ApiClient.new
        client.api_auth(token)
        response = client.exec(Api::Posts::New)

        response.should send_json(200, logged_in: true)
      end
    end
  end

  describe "#check_authorization" do
    it "denies authorization" do
      user = UserFactory.create
      UserOptionsFactory.create &.user_id(user.id)

      CreateBearerLogin.create(
        params(name: "secret token"),
        scopes: [BearerScope.new(Api::Posts::Create).to_s],
        user: user
      ) do |operation, bearer_login|
        bearer_login = bearer_login.not_nil!

        token = BearerLoginCredentials.new(operation, bearer_login)

        client = ApiClient.new
        client.api_auth(token)

        response = client.exec(Api::Posts::Create)

        response.should send_json(403, authorized: false)
      end
    end

    it "grants authorization" do
      user = UserFactory.create &.level(:admin)
      UserOptionsFactory.create &.user_id(user.id)

      CreateBearerLogin.create(
        params(name: "secret token"),
        scopes: [BearerScope.new(Api::Posts::Create).to_s],
        user: user
      ) do |operation, bearer_login|
        bearer_login = bearer_login.not_nil!

        token = BearerLoginCredentials.new(operation, bearer_login)

        client = ApiClient.new
        client.api_auth(token)

        response = client.exec(Api::Posts::Create)

        response.should send_json(200, current_bearer: user.id)
      end
    end
  end
end
