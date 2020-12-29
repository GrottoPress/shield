require "../../../spec_helper"

describe Shield::Api::EmailConfirmationPipes do
  describe "#pin_email_confirmation_to_ip_address" do
    it "accepts email confirmation from same IP" do
      password = "password4APASSWORD<"

      StartEmailConfirmation.create(
        params(email: "user@example.tld"),
        remote_ip: Socket::IPAddress.new("128.0.0.2", 5000)
      ) do |operation, email_confirmation|
        email_confirmation = email_confirmation.not_nil!

        token = BearerToken.new(operation, email_confirmation)

        response = ApiClient.exec(
          Api::EmailConfirmationCurrentUser::Create,
          token: token,
          user: {
            password: password,
            password_notify: true,
            login_notify: true
          }
        )

        response.should send_json(200, {status: "success"})
      end
    end

    it "rejects email confirmation from different IP" do
      password = "password4APASSWORD<"

      StartEmailConfirmation.create(
        params(email: "user@example.tld"),
        remote_ip: Socket::IPAddress.new("129.0.0.3", 9000)
      ) do |operation, email_confirmation|
        email_confirmation = email_confirmation.not_nil!

        token = BearerToken.new(operation, email_confirmation)

        response = ApiClient.exec(
          Api::EmailConfirmationCurrentUser::Create,
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
