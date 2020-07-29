require "../../spec_helper"

describe Shield::VerifyPasswordReset do
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

      session.set(:password_reset_id, password_reset.id.to_s)

      sleep 3

      password_reset.status.started?.should be_true
      VerifyPasswordReset.new(session: session).submit
      password_reset.reload.status.started?.should be_false
    end
  end
end
