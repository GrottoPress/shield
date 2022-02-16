require "../../spec_helper"

describe Shield::EndPasswordReset do
  it "ends password reset" do
    email = "user@example.tld"

    UserFactory.create &.email(email)

    session = Lucky::Session.new

    StartPasswordReset.create(
      params(email: email),
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    ) do |operation, password_reset|
      password_reset.should be_a(PasswordReset)
      password_reset =  password_reset.not_nil!

      PasswordResetSession.new(session).set(operation, password_reset)

      password_reset.status.active?.should be_true

      EndPasswordReset.update(
        password_reset,
        session: session
      ) do |_operation, updated_password_reset|
        _operation.saved?.should be_true

        updated_password_reset.status.active?.should be_false
      end
    end

    PasswordResetSession.new(session).password_reset_id?.should be_nil
    PasswordResetSession.new(session).password_reset_token?.should be_nil
  end
end
