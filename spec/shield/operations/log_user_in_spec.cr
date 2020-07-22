require "../../spec_helper"

describe Shield::LogUserIn do
  it "logs user in" do
    email = "user@example.tld"
    password = "password12U password"

    create_current_user!(
      email: email,
      password: password,
      password_confirmation: password
    )

    session = Lucky::Session.new
    ip_address = Socket::IPAddress.new("0.0.0.0", 0)

    LogUserIn.create(
      email: email,
      password: password,
      session: session,
      remote_ip: ip_address
    ) do |operation, login|
      login.should be_a(Login)

      login.try(&.active?).should be_true
      login.try(&.ip_address).should eq(ip_address)

      session.get?(:login_id).should eq("#{login.try(&.id)}")
      session.get?(:login_token).to_s.should_not be_empty
    end
  end

  it "forgets login" do
    Shield.temp_config(login_expiry: 2.seconds) do
      email = "user@example.tld"
      password = "password12U/password"

      create_current_user!(
        email: email,
        password: password,
        password_confirmation: password
      )

      login = LogUserIn.create!(
        email: email,
        password: password,
        session: Lucky::Session.new,
        remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
      )

      login.expired?.should be_false
      sleep 3
      login.expired?.should be_true
    end
  end

  it "requires valid IP address" do
    LogUserIn.create(
      email: "incorrect@example.tld",
      password: "password12U~password",
      session: Lucky::Session.new,
      remote_ip: nil
    ) do |operation, login|
      login.should be_nil

      operation.ip_address.errors.find(&.includes? " required").should(be_nil)

      operation
        .ip_address
        .errors
        .find(&.includes? "not be determined")
        .should_not(be_nil)
    end
  end

  it "rejects incorrect email" do
    password = "password12U~password"

    create_current_user!(password: password, password_confirmation: password)

    LogUserIn.create(
      email: "incorrect@example.tld",
      password: password,
      session: Lucky::Session.new,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    ) do |operation, login|
      login.should be_nil

      operation
        .email
        .errors
        .find(&.includes? " incorrect")
        .should_not(be_nil)
    end
  end

  it "rejects incorrect password" do
    email = "user@example.tld"
    password = "password12U~password"

    create_current_user!(
      email: email,
      password: password,
      password_confirmation: password
    )

    LogUserIn.create(
      email: email,
      password: "assword12U~passwor",
      session: Lucky::Session.new,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    ) do |operation, login|
      login.should be_nil

      operation
        .password
        .errors
        .find(&.includes? " incorrect")
        .should_not(be_nil)
    end
  end

  it "sends login notification" do
    email = "user@example.tld"
    password = "pass)word1Apassword"

    user = create_current_user!(
      email: email,
      password: password,
      password_confirmation: password,
      login_notify: true
    )

    LogUserIn.create(
      email: email,
      password: password,
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

    user = create_current_user!(
      email: email,
      password: password,
      password_confirmation: password,
      login_notify: false
    )

    LogUserIn.create(
      email: email,
      password: password,
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
