require "../../spec_helper"

describe Shield::PasswordResetVerifier do
  it "deactivates password reset when expired but active" do
    Shield.temp_config(password_reset_expiry: 2.seconds) do
      email = "user@example.tld"
      password = "password12U password"

      UserBox.create &.email(email)
        .password_digest(CryptoHelper.hash_bcrypt(password))

      password_reset = StartPasswordReset.create!(
        params(email: email),
        remote_ip: Socket::IPAddress.new("1.2.3.4", 5)
      )

      password_reset.status.started?.should be_true

      password_reset_params = PasswordResetParams.new(params(
        token: PasswordResetHelper.token(password_reset.id, "abcdef")
      ))

      sleep 3

      password_reset.status.started?.should be_true
      password_reset_params.verify.should be_nil
      password_reset.reload.status.expired?.should be_true
    end
  end
end
