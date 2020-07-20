require "../../spec_helper"

describe Shield::Login do
  describe "#authenticate?" do
    it "deactivates login when expired but active" do
      Shield.temp_config(login_expiry: 2.seconds) do
        email = "user@example.tld"
        password = "password12U password"

        create_current_user!(
          email: email,
          password: password,
          password_confirmation: password
        )

        login = LogUserIn.create!(
          email: email,
          password: password,
          session: Lucky::Session.new
        )

        sleep 3

        login.active?.should be_true
        login.authenticate?("abc")
        login.reload.active?.should be_false
      end
    end
  end
end
