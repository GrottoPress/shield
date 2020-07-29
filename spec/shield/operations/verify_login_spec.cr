require "../../spec_helper"

describe Shield::VerifyLogin do
  it "deactivates login when expired but active" do
    Shield.temp_config(login_expiry: 2.seconds) do
      email = "user@example.tld"
      password = "password12U password"

      create_current_user!(
        email: email,
        password: password,
        password_confirmation: password
      )

      session = Lucky::Session.new

      login = LogUserIn.create!(
        email: email,
        password: password,
        session: session,
        remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
      )

      sleep 3

      login.status.started?.should be_true
      VerifyLogin.new(session: session).submit
      login.reload.status.started?.should be_false
    end
  end
end
