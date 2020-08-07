require "../../spec_helper"

describe PasswordResetSession do
  it "deactivates password reset when expired but active" do
    Shield.temp_config(password_reset_expiry: 2.seconds) do
      email = "user@example.tld"
      password = "password12U password"

      create_current_user!(
        email: email,
        password: password,
        password_confirmation: password
      )

      session = Lucky::Session.new

      password_reset = StartPasswordReset.create!(
        email: email,
        remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
      )
      password_reset.status.started?.should be_true

      password_reset_session = PasswordResetSession.new(session)
      password_reset_session.set(password_reset.id, "abcdef")

      sleep 3

      password_reset_session.verify
      password_reset.reload.status.expired?.should be_true
    end
  end
end
