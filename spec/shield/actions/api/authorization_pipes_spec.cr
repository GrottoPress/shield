require "../../../spec_helper"

describe Shield::Api::AuthorizationPipes do
  describe "#check_authorization" do
    context "for logins with regular passwords" do
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

    context "for logins with user-generated bearer tokens" do
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

          response.should send_json(200, current_bearer_user: user.id)
        end
      end
    end
  end
end
