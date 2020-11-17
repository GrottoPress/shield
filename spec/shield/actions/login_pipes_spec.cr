require "../../spec_helper"

describe Shield::LoginPipes do
  describe "#require_logged_in" do
    it "requires logged in" do
      response = ApiClient.exec(CurrentLogin::Destroy)

      response.status.should eq(HTTP::Status::FOUND)
      response.headers["X-Logged-In"].should eq("false")
    end
  end

  describe "#require_logged_out" do
    it "requires logged out" do
      email = "user@example.tld"
      password = "password4APASSWORD<"

      UserBox.create &.email(email)
        .password_digest(CryptoHelper.hash_bcrypt(password))

      client = ApiClient.new

      response = client.exec(CurrentLogin::Create, login: {
        email: email,
        password: password
      })

      response.status.should eq(HTTP::Status::FOUND)

      client.headers("Cookie": response.headers["Set-Cookie"])
      response = client.exec(CurrentLogin::Create)

      response.status.should eq(HTTP::Status::FOUND)
      response.headers["X-Logged-In"].should eq("true")
    end
  end

  describe "#pin_login_to_ip_address" do
    it "accepts login from same IP" do
      email = "user@example.tld"
      password = "password4APASSWORD<"

      user = UserBox.create &.email(email)
        .level(User::Level.new :admin)
        .password_digest(CryptoHelper.hash_bcrypt(password))

      client = ApiClient.new

      response = client.exec(CurrentLogin::Create, login: {
        email: email,
        password: password
      })

      response.status.should eq(HTTP::Status::FOUND)

      client.headers("Cookie": response.headers["Set-Cookie"])
      response = client.exec(Users::Show.with(user_id: user.id))

      response.should send_json(200, user: user.id)
    end

    it "rejects login from different IP" do
      email = "user@example.tld"
      password = "password4APASSWORD<"

      user = UserBox.create &.email(email)
        .level(User::Level.new :admin)
        .password_digest(CryptoHelper.hash_bcrypt(password))

      client = ApiClient.new

      response = client.exec(CurrentLogin::Create, login: {
        email: email,
        password: password
      })

      response.status.should eq(HTTP::Status::FOUND)

      client.headers("Cookie": response.headers["Set-Cookie"])
      response = client.exec(Users::Edit.with(user_id: user.id))

      response.status.should eq(HTTP::Status::FOUND)
      response.headers["X-Ip-Address-Changed"].should eq("true")
    end
  end
end
