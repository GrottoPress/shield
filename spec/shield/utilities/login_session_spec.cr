require "../../spec_helper"

describe LoginSession do
  it "deactivates login when expired but active" do
    Shield.temp_config(login_expiry: 2.seconds) do
      email = "user@example.tld"
      password = "password12U password"

      UserBox.create &.email(email)
        .password_digest(CryptoHelper.hash_bcrypt(password))

      session = Lucky::Session.new

      login = LogUserIn.create!(
        params(email: email, password: password),
        session: session,
        remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
      )

      sleep 3

      login.status.started?.should be_true
      LoginSession.new(session).verify
      login.reload.status.expired?.should be_true
    end
  end
end
