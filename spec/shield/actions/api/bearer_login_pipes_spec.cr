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

    it "requires logged in" do
      response = ApiClient.exec(Api::Posts::Index)

      response.headers["WWW-Authenticate"]?.should_not be_nil
      response.should send_json(401, logged_in: false)
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

  describe "#check_authorization" do
    it "denies authorization when scopes insufficient" do
      user = UserFactory.create &.level(:admin)
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

        response = client.exec(Api::Posts::Create)

        response.should send_json(403, authorized: false)
      end
    end

    it "denies authorization when user not allowed access to route" do
      user = UserFactory.create
      UserOptionsFactory.create &.user_id(user.id)

      CreateBearerLogin.create(
        params(name: "secret token"),
        scopes: ["api.posts.create"],
        allowed_scopes: ["api.posts.update", "api.posts.create"],
        user: user
      ) do |operation, bearer_login|
        bearer_login = bearer_login.not_nil!

        token = BearerToken.new(operation, bearer_login)

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
        scopes: ["api.posts.create"],
        allowed_scopes: ["api.posts.update", "api.posts.create"],
        user: user
      ) do |operation, bearer_login|
        bearer_login = bearer_login.not_nil!

        token = BearerToken.new(operation, bearer_login)

        client = ApiClient.new
        client.api_auth(token)

        response = client.exec(Api::Posts::Create)

        response.should send_json(200, current_bearer: user.id)
      end
    end
  end
end
