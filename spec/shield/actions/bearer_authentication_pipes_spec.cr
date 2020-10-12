require "../../spec_helper"

describe Shield::BearerAuthenticationPipes do
  describe "#require_logged_in" do
    it "allows login from session" do
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

      client.headers("Cookie": response.headers["Set-Cookie"])
      response = client.exec(Posts::Index)

      response.should send_json(200, current_user: user.id)
    end

    it "requires logged in" do
      response = ApiClient.exec(Posts::Index)

      response.headers["WWW-Authenticate"]?.should_not be_nil
      response.should send_json(401, logged_in: false)
    end
  end

  describe "#require_logged_out" do
    it "rejects session logins" do
      email = "user@example.tld"
      password = "password4APASSWORD<"

      UserBox.create &.email(email)
        .password_digest(CryptoHelper.hash_bcrypt(password))

      client = ApiClient.new

      response = client.exec(CurrentLogin::Create, login: {
        email: email,
        password: password
      })

      response.should send_json(200, session: 1)

      client.headers("Cookie": response.headers["Set-Cookie"])
      response = client.exec(Posts::New)

      response.should send_json(200, logged_in: true)
    end

    it "rejects bearer logins" do
      email = "user@example.tld"
      password = "password4APASSWORD<"

      UserBox.create &.email(email)
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
        scopes: ["posts.index","posts.new"]
      })

      body = JSON.parse(response.body)

      bearer_header = BearerLoginHelper.authorization_header(
        body["bearer_login"]?.to_s,
        body["bearer_token"]?.to_s
      )

      client = ApiClient.new
      client.headers("Authorization": bearer_header)
      response = client.exec(Posts::New)

      response.should send_json(200, logged_in: true)
    end
  end

  describe "#check_authorization" do
    context "for session logins" do
      it "denies authorization" do
        password = "password_1Apassword"

        user = UserBox.create &.password_digest(
          CryptoHelper.hash_bcrypt(password)
        )

        client = ApiClient.new

        response = client.exec(CurrentLogin::Create, login: {
          email: user.email,
          password: password
        })

        response.should send_json(200, session: 1)

        client.headers("Cookie": response.headers["Set-Cookie"])
        response = client.exec(Posts::Create)

        response.should send_json(403, authorized: false)
      end

      it "grants authorization" do
        password = "password_1Apassword"

        user = UserBox.create &.level(User::Level.new(:admin))
          .password_digest(CryptoHelper.hash_bcrypt(password))

        client = ApiClient.new

        response = client.exec(CurrentLogin::Create, login: {
          email: user.email,
          password: password
        })

        response.should send_json(200, session: 1)

        client.headers("Cookie": response.headers["Set-Cookie"])
        response = client.exec(Posts::Create)

        response.should send_json(200, current_user: user.id)
      end
    end

    context "for bearer logins" do
      it "denies authorization when scopes insufficient" do
        password = "password_1Apassword"

        user = UserBox.create &.level(User::Level.new(:admin))
          .password_digest(CryptoHelper.hash_bcrypt(password))

        client = ApiClient.new

        response = client.exec(CurrentLogin::Create, login: {
          email: user.email,
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
        response = client.exec(Posts::Create)

        response.should send_json(403, authorized: false)
      end

      it "denies authorization when route access not allowed" do
        password = "password_1Apassword"

        user = UserBox.create &.password_digest(
          CryptoHelper.hash_bcrypt(password)
        )

        client = ApiClient.new

        response = client.exec(CurrentLogin::Create, login: {
          email: user.email,
          password: password
        })

        response.should send_json(200, session: 1)

        client.headers("Cookie": response.headers["Set-Cookie"])
        response = client.exec(BearerLogins::Create, bearer_login: {
          name: "secret token",
          scopes: ["posts.create"]
        })

        body = JSON.parse(response.body)

        bearer_header = BearerLoginHelper.authorization_header(
          body["bearer_login"]?.to_s,
          body["bearer_token"]?.to_s
        )

        client = ApiClient.new
        client.headers("Authorization": bearer_header)
        response = client.exec(Posts::Create)

        response.should send_json(403, authorized: false)
      end

      it "grants authorization" do
        password = "password_1Apassword"

        user = UserBox.create &.level(User::Level.new(:admin))
          .password_digest(CryptoHelper.hash_bcrypt(password))

        client = ApiClient.new

        response = client.exec(CurrentLogin::Create, login: {
          email: user.email,
          password: password
        })

        response.should send_json(200, session: 1)

        client.headers("Cookie": response.headers["Set-Cookie"])
        response = client.exec(BearerLogins::Create, bearer_login: {
          name: "secret token",
          scopes: ["posts.create"]
        })

        body = JSON.parse(response.body)

        bearer_header = BearerLoginHelper.authorization_header(
          body["bearer_login"]?.to_s,
          body["bearer_token"]?.to_s
        )

        client = ApiClient.new
        client.headers("Authorization": bearer_header)
        response = client.exec(Posts::Create)

        response.should send_json(200, current_bearer_user: user.id)
      end
    end
  end
end
