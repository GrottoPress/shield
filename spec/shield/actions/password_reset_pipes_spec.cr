require "../../spec_helper"

describe Shield::PasswordResetPipes do
  describe "#pin_password_reset_to_ip_address" do
    it "accepts password reset from same IP" do
      email = "user@example.tld"
      password = "password4APASSWORD<"

      UserBox.create &.email(email)
        .level(User::Level.new :admin)
        .password_digest(CryptoHelper.hash_bcrypt(password))

      StartPasswordReset.create(
        params(email: email),
        remote_ip: Socket::IPAddress.new("128.0.0.2", 5000)
      ) do |operation, password_reset|
        password_reset = password_reset.not_nil!

        session = Lucky::Session.new
        PasswordResetSession.new(session).set(password_reset, operation)

        client = ApiClient.new
        client.set_cookie_from_session(session)

        response = client.exec(PasswordResets::Edit)

        response.body.should eq("PasswordResets::EditPage")
      end
    end

    it "rejects password reset from different IP" do
      email = "user@example.tld"
      password = "password4APASSWORD<"

      UserBox.create &.email(email)
        .level(User::Level.new :admin)
        .password_digest(CryptoHelper.hash_bcrypt(password))

      StartPasswordReset.create(
        params(email: email),
        remote_ip: Socket::IPAddress.new("128.0.0.2", 5000)
      ) do |operation, password_reset|
        password_reset = password_reset.not_nil!

        session = Lucky::Session.new
        PasswordResetSession.new(session).set(password_reset, operation)

        client = ApiClient.new
        client.set_cookie_from_session(session)

        response = client.exec(PasswordResets::Update)

        response.status.should eq(HTTP::Status::FOUND)
        response.headers["X-Ip-Address-Changed"].should eq("true")
      end
    end
  end
end
