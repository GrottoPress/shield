require "../../../spec_helper"

describe Shield::Api::AuthenticationHelpers do
  describe "#current_login" do
    it "does not use session authentication" do
      email = "user@example.tld"
      password = "password4APASSWORD<"

      user = UserBox.create &.email(email)
        .password_digest(CryptoHelper.hash_bcrypt(password))

      client = ApiClient.new

      response = client.exec(CurrentLogin::Create, login: {
        email: email,
        password: password
      })

      response.should send_json(200, session: 1)

      body = JSON.parse(response.body)

      bearer_header = LoginHelper.bearer_header(
        body["current_login"]?.to_s,
        body["login_token"]?.to_s
      )

      client.headers("Cookie": response.headers["Set-Cookie"])
      response = client.exec(Api::Posts::Index)

      response.status_code.should eq(401)

      client = ApiClient.new
      client.headers("Authorization": bearer_header)
      response = client.exec(Api::Posts::Index)

      response.should send_json(200, current_user: user.id)
    end
  end

  describe "#current_bearer_user" do
    it "works" do
      email = "user@example.tld"
      password = "password4APASSWORD<"

      user = UserBox.create &.email(email)
        .password_digest(CryptoHelper.hash_bcrypt(password))

      CreateBearerLogin.create(
        params(name: "secret token"),
        scopes: ["api.posts.index"],
        all_scopes: ["api.posts.update", "api.posts.index"],
        user_id: user.id
      ) do |operation, bearer_login|
        bearer_login = bearer_login.not_nil!

        bearer_header = BearerLoginHelper.bearer_header(bearer_login, operation)

        client = ApiClient.new
        client.headers("Authorization": bearer_header)
        response = client.exec(Api::Posts::Index)

        response.should send_json(200, current_bearer_user: user.id)
      end
    end
  end
end
