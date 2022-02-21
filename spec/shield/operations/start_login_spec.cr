require "../../spec_helper"

describe Shield::StartLogin do
  it "logs user in" do
    email = "user@example.tld"
    password = "password12U password"

    user = UserFactory.create &.email(email).password(password)
    UserOptionsFactory.create &.user_id(user.id)

    session = Lucky::Session.new
    ip_address = Socket::IPAddress.new("129.0.0.5", 5555)

    login = LogUserIn.create!(
      params(email: email, password: password),
      session: session,
      remote_ip: ip_address
    )

    login.status.active?.should be_true
    login.inactive_at.should_not be_nil
    login.ip_address.should eq(ip_address.address)

    LoginSession.new(session).login_id.should eq(login.id)
    LoginSession.new(session).login_token.should_not be_empty
  end

  it "rejects incorrect email" do
    password = "password12U~password"

    user = UserFactory.create &.password(password)
    UserOptionsFactory.create &.user_id(user.id)

    LogUserIn.create(
      params(email: "incorrect@example.tld", password: password),
      session: Lucky::Session.new,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    ) do |operation, _|
      operation.saved?.should be_false

      operation.user_id.should_not have_error
      operation.password.should have_error("operation.error.login_failed")
    end
  end

  it "rejects incorrect password" do
    email = "user@example.tld"
    password = "password12U~password"

    user = UserFactory.create &.email(email).password(password)
    UserOptionsFactory.create &.user_id(user.id)

    LogUserIn.create(
      params(email: email, password: "assword12U~passwor"),
      session: Lucky::Session.new,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    ) do |operation, _|
      operation.saved?.should be_false

      operation.password.should have_error("operation.error.login_failed")
    end
  end
end
