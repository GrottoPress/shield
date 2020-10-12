require "../../spec_helper"

describe Shield::BearerAuthenticationHelpers do
  describe "#current_bearer_user" do
    it "works" do
      email = "user@example.tld"
      password = "password4APASSWORD<"

      email_2 = "user@domain.tld"
      password_2 = "assword4A,PASSWOR"

      user = UserBox.create &.email(email)
        .password_digest(CryptoHelper.hash_bcrypt(password))

      client = ApiClient.new

      response = client.exec(CurrentLogin::Create, login: {
        email: email,
        password: password
      })

      response.should send_json(200, session: 1)

      client.headers("Cookie": response.headers["Set-Cookie"])
      response = client.exec(BearerLogins::Create, bearer_login: {
        name: "secret token",
        scopes: ["posts.index"]
      })

      body = JSON.parse(response.body)

      bearer_header = BearerLoginHelper.authorization_header(
        body["bearer_login"]?.to_s,
        body["bearer_token"]?.to_s
      )

      client = ApiClient.new
      client.headers("Authorization": bearer_header)
      response = client.exec(Posts::Index)

      response.should send_json(200, current_bearer_user: user.id)
    end
  end
end
