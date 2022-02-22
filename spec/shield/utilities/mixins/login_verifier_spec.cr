require "../../../spec_helper"

describe Shield::LoginVerifier do
  describe "#verify" do
    it "verifies login" do
      email = "user@example.tld"
      password = "password12U password"

      user = UserFactory.create &.email(email).password(password)
      UserOptionsFactory.create &.user_id(user.id)

      session = Lucky::Session.new
      session_2 = Lucky::Session.new

      StartCurrentLogin.create!(
        params(email: email, password: password),
        session: session,
        remote_ip: Socket::IPAddress.new("1.2.3.4", 5)
      )

      LoginSession.new(session).verify.should be_a(Login)
      LoginSession.new(session_2).verify.should be_nil
    end
  end
end
