require "../../spec_helper"

describe Shield::AuthorizationPipes do
  describe "#check_authorization" do
    it "denies authorization" do
      password = "password_1Apassword"

      user = UserBox.create &.password_digest(
        CryptoHelper.hash_bcrypt(password)
      )

      client = ApiClient.new

      response = client.exec(Logins::Create, login: {
        email: user.email,
        password: password
      })

      response.should send_json(200, session: 1)

      client.headers("Cookie": response.headers["Set-Cookie"])
      response = client.exec(Users::Show.with(user_id: user.id))

      response.should send_json(403, authorized: false)
    end

    it "grants authorization" do
      password = "password_1Apassword"

      user = UserBox.create &.level(User::Level.new(:admin))
        .password_digest(CryptoHelper.hash_bcrypt(password))

      client = ApiClient.new

      response = client.exec(Logins::Create, login: {
        email: user.email,
        password: password
      })

      response.should send_json(200, session: 1)

      client.headers("Cookie": response.headers["Set-Cookie"])
      response = client.exec(Users::Show.with(user_id: user.id))

      response.should send_json(200, user: user.id)
    end
  end
end
