require "../../spec_helper"

describe Shield::LogUserIn do
  it "logs user in" do
    email = "user@example.tld"
    password = "password12U password"

    UserBox.create &.email(email)
      .password_digest(CryptoHelper.hash_bcrypt(password))

    session = Lucky::Session.new
    ip_address = Socket::IPAddress.new("129.0.0.5", 5555)

    login = LogUserIn.create!(
      params(email: email, password: password),
      session: session,
      remote_ip: ip_address
    )

    login.status.started?.should be_true
    login.ip_address.should eq(ip_address.address)

    LoginSession.new(session).login_id!.should eq(login.id)
    LoginSession.new(session).login_token!.should_not be_empty
  end

  it "requires valid IP address" do
    LogUserIn.create(
      params(email: "incorrect@example.tld", password: "password12U~password"),
      session: Lucky::Session.new,
      remote_ip: nil
    ) do |operation, login|
      login.should be_nil

      assert_invalid(operation.ip_address, "not be determined")
    end
  end

  it "rejects incorrect email" do
    password = "password12U~password"

    UserBox.create &.password_digest(CryptoHelper.hash_bcrypt(password))

    LogUserIn.create(
      params(email: "incorrect@example.tld", password: password),
      session: Lucky::Session.new,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    ) do |operation, login|
      login.should be_nil

      # operation.user_id.errors.should be_empty
      assert_valid(operation.user_id)
      assert_invalid(operation.email, " incorrect")
    end
  end

  it "rejects incorrect password" do
    email = "user@example.tld"
    password = "password12U~password"

    UserBox.create &.email(email)
      .password_digest(CryptoHelper.hash_bcrypt(password))

    LogUserIn.create(
      params(email: email, password: "assword12U~passwor"),
      session: Lucky::Session.new,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    ) do |operation, login|
      login.should be_nil

      assert_invalid(operation.password, " incorrect")
    end
  end

  it "sends login notification" do
    email = "user@example.tld"
    password = "pass)word1Apassword"

    UserBox.create &.email(email)
      .password_digest(CryptoHelper.hash_bcrypt(password))
      .login_notify(true)

    LogUserIn.create(
      params(email: email, password: password),
      session: Lucky::Session.new,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    ) do |operation, login|
      operation.saved?.should be_true

      LoginNotificationEmail.new(operation, login.not_nil!).should(be_delivered)
    end
  end

  it "does not send login notification" do
    password = "pass)word1Apassword"
    email = "user@example.tld"

    UserBox.create &.email(email)
      .password_digest(CryptoHelper.hash_bcrypt(password))
      .login_notify(false)

    LogUserIn.create(
      params(email: email, password: password),
      session: Lucky::Session.new,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    ) do |operation, login|
      operation.saved?.should be_true

      LoginNotificationEmail
        .new(operation, login.not_nil!)
        .should_not(be_delivered)
    end
  end
end
