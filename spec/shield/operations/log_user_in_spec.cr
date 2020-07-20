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
    cookies = Lucky::CookieJar.empty_jar

    LogUserIn.create(
      email: email,
      password: password,
      remember_login: true,
      session: session,
      cookies: cookies
    ) do |operation, login|
      login.should be_a(Login)

      login.try &.active?.should be_true

      session.get?(:login).should eq("#{login.try(&.id)}")
      cookies.get?(:login).should eq("#{login.try(&.id)}")

      session.get?(:login_token).to_s.should_not be_empty
      cookies.get?(:login_token).to_s.should_not be_empty

      session.get?(:login_token).should eq(cookies.get? :login_token)
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

      session = Lucky::Session.new
      cookies = Lucky::CookieJar.empty_jar

      login = LogUserIn.create!(
        email: email,
        password: password,
        remember_login: true,
        session: session,
        cookies: cookies
      )

      cookies.get_raw(:login).expired?.should be_false
      cookies.get_raw(:login_token).expired?.should be_false
      login.expired?.should be_false

      sleep 3

      cookies.get_raw(:login).expired?.should be_true
      cookies.get_raw(:login_token).expired?.should be_true
      login.expired?.should be_true
    end
  end

  it "rejects incorrect email" do
    password = "password12U~password"

    create_current_user!(password: password, password_confirmation: password)

    LogUserIn.create(
      email: "incorrect@example.tld",
      password: password,
      session: Lucky::Session.new,
      cookies: Lucky::CookieJar.empty_jar
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
      cookies: Lucky::CookieJar.empty_jar
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
      cookies: Lucky::CookieJar.empty_jar
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
      cookies: Lucky::CookieJar.empty_jar
    ) do |operation, login|
      operation.saved?.should be_true

      LoginNotificationEmail
        .new(operation, login.not_nil!)
        .should_not(be_delivered)
    end
  end

  it "saves IP address" do
    password = "pass)word1Apassword"
    email = "user@example.tld"

    create_current_user!(
      email: email,
      password: password,
      password_confirmation: password
    )

    ip = Socket::IPAddress.new("127.0.0.1", 12345)

    login = LogUserIn.create!(
      email: email,
      password: password,
      ip_address: ip,
      session: Lucky::Session.new,
      cookies: Lucky::CookieJar.empty_jar
    )

    login.ip_address.should eq(ip)
  end
end
