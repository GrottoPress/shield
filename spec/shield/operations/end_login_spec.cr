require "../../spec_helper"

describe Shield::EndLogin do
  it "logs user out" do
    email = "user@example.tld"
    password = "password12U//password"

    user = UserFactory.create &.email(email).password(password)
    UserOptionsFactory.create &.user_id(user.id)

    session = Lucky::Session.new

    login = StartCurrentLogin.create!(
      params(email: email, password: password),
      session: session,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    )

    LoginSession.new(session).login_id?.should_not be_nil

    login.status.active?.should be_true

    EndCurrentLogin.update(
      LoginSession.new(session).login,
      session: session
    ) do |operation, updated_login|
      operation.saved?.should be_true

      updated_login.status.active?.should be_false
      LoginSession.new(session).login_id?.should be_nil
    end
  end
end
