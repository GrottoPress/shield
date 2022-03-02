require "../../../spec_helper"

describe Shield::Api::PasswordResetPipes do
  describe "#pin_password_reset_to_ip_address" do
    it "accepts password reset from same IP" do
      email = "user@example.tld"
      password = "password4APASSWORD<"

      UserFactory.create &.email(email)
        .level(:admin)
        .password(password)

      StartPasswordReset.create(
        params(email: email),
        remote_ip: Socket::IPAddress.new("128.0.0.2", 5000)
      ) do |operation, password_reset|
        password_reset = password_reset.not_nil!

        token = BearerToken.new(operation, password_reset)

        response = ApiClient.exec(
          Api::PasswordResets::Update,
          token: token,
          password_reset: {
            password: password,
            password_notify: true,
            login_notify: true
          }
        )

        response.should send_json(200, {status: "success"})
      end
    end

    it "rejects password reset from different IP" do
      email = "user@example.tld"
      password = "password4APASSWORD<"

      UserFactory.create &.email(email)
        .level(:admin)
        .password(password)

      StartPasswordReset.create(
        params(email: email),
        remote_ip: Socket::IPAddress.new("129.0.0.3", 5000)
      ) do |operation, password_reset|
        password_reset = password_reset.not_nil!

        token = BearerToken.new(operation, password_reset)

        response = ApiClient.exec(
          Api::PasswordResets::Update,
          token: token,
          user: {
            password: password,
            password_notify: true,
            login_notify: true
          }
        )

        response.should send_json(403, ip_address_changed: true)
      end
    end
  end
end
