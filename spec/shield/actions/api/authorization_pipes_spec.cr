require "../../../spec_helper"

describe Shield::Api::AuthorizationPipes do
  describe "#check_authorization" do
    context "for logins with regular passwords" do
      it "denies authorization" do
        password = "password_1Apassword"

        user = UserBox.create &.password_digest(
          CryptoHelper.hash_bcrypt(password)
        )

        LogUserIn.create(
          params(email: user.email, password: password),
          remote_ip: Socket::IPAddress.new("129.0.0.5", 5555)
        ) do |operation, login|
          login = login.not_nil!

          bearer_header = LoginHelper.bearer_header(login, operation)

          client = ApiClient.new
          client.headers("Authorization": bearer_header)
          response = client.exec(Api::Posts::Create)

          response.should send_json(403, authorized: false)
        end
      end

      it "grants authorization" do
        password = "password_1Apassword"

        user = UserBox.create &.level(User::Level.new(:admin))
          .password_digest(CryptoHelper.hash_bcrypt(password))

        LogUserIn.create(
          params(email: user.email, password: password),
          remote_ip: Socket::IPAddress.new("129.0.0.5", 5555)
        ) do |operation, login|
          login = login.not_nil!

          bearer_header = LoginHelper.bearer_header(login, operation)

          client = ApiClient.new
          client.headers("Authorization": bearer_header)
          response = client.exec(Api::Posts::Create)

          response.should send_json(200, current_user: user.id)
        end
      end
    end

    context "for logins with user-generated bearer tokens" do
      it "denies authorization when scopes insufficient" do
        user = UserBox.create &.level(User::Level.new :admin)

        CreateBearerLogin.create(
          params(name: "secret token"),
          scopes: ["api.posts.index"],
          all_scopes: ["api.posts.update", "api.posts.index"],
          user_id: user.id
        ) do |operation, bearer_login|
          bearer_login = bearer_login.not_nil!

          bearer_header = BearerLoginHelper.bearer_header(
            bearer_login,
            operation
          )

          client = ApiClient.new
          client.headers("Authorization": bearer_header)
          response = client.exec(Api::Posts::Create)

          response.should send_json(403, authorized: false)
        end
      end

      it "denies authorization when user not allowed access to route" do
        user = UserBox.create

        CreateBearerLogin.create(
          params(name: "secret token"),
          scopes: ["api.posts.create"],
          all_scopes: ["api.posts.update", "api.posts.create"],
          user_id: user.id
        ) do |operation, bearer_login|
          bearer_login = bearer_login.not_nil!

          bearer_header = BearerLoginHelper.bearer_header(
            bearer_login,
            operation
          )

          client = ApiClient.new
          client.headers("Authorization": bearer_header)
          response = client.exec(Api::Posts::Create)

          response.should send_json(403, authorized: false)
        end
      end

      it "grants authorization" do
        user = UserBox.create &.level(User::Level.new :admin)

        CreateBearerLogin.create(
          params(name: "secret token"),
          scopes: ["api.posts.create"],
          all_scopes: ["api.posts.update", "api.posts.create"],
          user_id: user.id
        ) do |operation, bearer_login|
          bearer_login = bearer_login.not_nil!

          bearer_header = BearerLoginHelper.bearer_header(
            bearer_login,
            operation
          )

          client = ApiClient.new
          client.headers("Authorization": bearer_header)
          response = client.exec(Api::Posts::Create)

          response.should send_json(200, current_bearer_user: user.id)
        end
      end
    end
  end
end
