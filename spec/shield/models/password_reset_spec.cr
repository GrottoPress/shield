require "../../spec_helper"

describe Shield::PasswordReset do
  describe "#authenticate?" do
    it "deactivates password reset when expired but active" do
      Shield.temp_config(password_reset_expiry: 2.seconds) do
        email = "user@example.tld"
        password = "password12U password"

        create_current_user!(
          email: email,
          password: password,
          password_confirmation: password
        )

        password_reset = StartPasswordReset.create!(
          user_email: email,
          remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
        )

        sleep 3

        password_reset.active?.should be_true
        password_reset.authenticate?("abc")
        password_reset.reload.active?.should be_false
      end
    end
  end
end
