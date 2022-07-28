require "../../../spec_helper"

describe Shield::PasswordResetVerifier do
  describe "#verify" do
    it "verifies password reset" do
      email = "user@example.tld"
      password = "password12U password"

      UserFactory.create &.email(email).password(password)

      StartPasswordReset.create(
        params(email: email),
        remote_ip: Socket::IPAddress.new("1.2.3.4", 5)
      ) do |operation, password_reset|
        password_reset = password_reset.not_nil!

        token = BearerToken.new(operation, password_reset)
        token_2 = BearerToken.new("abcdef", 1)

        PasswordResetParams.new(params(token: token))
          .verify
          .should be_a(PasswordReset)

        PasswordResetParams.new(params(token: token_2)).verify.should be_nil
      end
    end
  end
end
