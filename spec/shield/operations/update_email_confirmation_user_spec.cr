require "../../spec_helper"

describe Shield::UpdateEmailConfirmationUser do
  it "updates user" do
    email = "user@example.tld"
    new_email = "user@domain.com"

    user = UserBox.create &.email(email)

    UpdateEmailConfirmationCurrentUser.update(
      user,
      params(email: new_email),
      current_login: nil,
      remote_ip: Socket::IPAddress.new("129.0.0.3", 5555)
    ) do |operation, updated_user|
      operation.saved?.should be_true

      operation.new_email.should eq(new_email)
      updated_user.email.should eq(email)

      operation.email_confirmation.should be_a(EmailConfirmation)
      operation.start_email_confirmation.should be_a(StartEmailConfirmation)
    end
  end

  it "updates user options" do
    user = UserBox.create &.login_notify(true)
      .password_notify(false)

    UpdateEmailConfirmationCurrentUser.update(
      user,
      params(login_notify: "false", password_notify: "true"),
      current_login: nil,
      remote_ip: Socket::IPAddress.new("129.0.0.3", 5555)
    ) do |operation, updated_user|
      operation.saved?.should be_true

      user_options = updated_user.options!
      user_options.login_notify.should be_false
      user_options.password_notify.should be_true
    end
  end

  it "fails when nested operation fails" do
    user = UserBox.create &.login_notify(true)
      .password_notify(true)

    UpdateEmailConfirmationCurrentUser2.update(
      user,
      params(login_notify: false, password_notify: false),
      current_login: nil,
      remote_ip: Socket::IPAddress.new("129.0.0.3", 5555)
    ) do |operation, updated_user|
      operation.saved?.should be_false

      user_options = updated_user.options!
      user_options.login_notify.should be_true
      user_options.password_notify.should be_true
    end
  end

  it "fails when attributes change and nested operation fails" do
    password = "password12U-password"
    new_password = "assword12U-passwor"

    user = UserBox.create &.login_notify(true)
      .password_notify(true)
      .password_digest(CryptoHelper.hash_bcrypt(password))

    UpdateEmailConfirmationCurrentUser2.update(
      user,
      params(
        password: new_password,
        login_notify: false,
        password_notify: false
      ),
      current_login: nil,
      remote_ip: Socket::IPAddress.new("129.0.0.3", 5555)
    ) do |operation, updated_user|
      operation.saved?.should be_false

      user_options = updated_user.options!
      user_options.login_notify.should be_true
      user_options.password_notify.should be_true
    end
  end
end
