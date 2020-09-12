require "../../../spec_helper"

describe Shield::UpdatePassword do
  it "updates password" do
    password = "password12U-password"
    new_password = "assword12U-passwor"

    user = UserBox.create &.password_digest(
      CryptoHelper.hash_bcrypt(password, 4)
    )

    UpdateCurrentUser.update!(
      user,
      params(password: new_password, password_confirmation: new_password),
      current_login: nil
    )

    CryptoHelper
      .verify_bcrypt?(new_password, user.reload.password_digest)
      .should(be_true)
  end

  it "does not update password if new password empty" do
    user = UserBox.create

    UpdateCurrentUser.update(
      user,
      params(password: "", password_confirmation: ""),
      current_login: nil
    ) do |operation, updated_user|
      operation.saved?.should be_true
      updated_user.password_digest.should eq(user.password_digest)
    end
  end

  it "sends password change notification" do
    password = "pass)word1Apassword"
    new_password = "ass)word1Apasswor"

    user = UserBox.create &.password_notify(true)
      .password_digest(CryptoHelper.hash_bcrypt(password, 4))

    UpdateCurrentUser.update(
      user,
      params(password: new_password, password_confirmation: new_password),
      current_login: nil
    ) do |operation, updated_user|
      operation.saved?.should be_true

      PasswordChangeNotificationEmail
        .new(operation, updated_user)
        .should(be_delivered)
    end
  end

  it "does not send password change notification" do
    password = "pass)word1Apassword"
    new_password = "ass)word1Apassword"

    user = UserBox.create &.password_digest(
      CryptoHelper.hash_bcrypt(password, 4)
    )

    UpdateCurrentUser.update(
      user,
      params(password: new_password, password_confirmation: new_password),
      password_notify: false,
      current_login: nil
    ) do |operation, updated_user|
      operation.saved?.should be_true
      PasswordChangeNotificationEmail
        .new(operation, updated_user)
        .should_not(be_delivered)
    end
  end

  it "does not send password change notification if password did not change" do
    password = "pass)word1Apassword"

    user = UserBox.create &.password_notify(true)
      .password_digest(CryptoHelper.hash_bcrypt(password, 4))

    UpdateCurrentUser.update(
      user,
      params(
        email: "user2@example.tld",
        password: password,
        password_confirmation: password
      ),
      current_login: nil
    ) do |operation, updated_user|
      operation.saved?.should be_true

      PasswordChangeNotificationEmail
        .new(operation, updated_user)
        .should_not(be_delivered)
    end
  end

  it "logs out everywhere when password changes" do
    email = "user@example.tld"
    password = "password12U-password"
    new_password = "assword12U-passwor"

    user = UserBox.create &.email(email)
      .password_digest(CryptoHelper.hash_bcrypt(password, 4))

    login_1 = LogUserIn.create!(
      params(email: email, password: password),
      session: Lucky::Session.new,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    )

    login_2 = LogUserIn.create!(
      params(email: email, password: password),
      session: Lucky::Session.new,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    )

    login_1.status.started?.should be_true
    login_2.status.started?.should be_true

    UpdateCurrentUser.update!(
      user,
      params(password: new_password, password_confirmation: new_password),
      current_login: nil
    )

    login_1.reload.status.started?.should be_false
    login_2.reload.status.started?.should be_false
  end

  it "retains current login when password changes" do
    email = "user@example.tld"
    password = "password12U-password"
    new_password = "assword12U-passwor"

    user = UserBox.create &.email(email)
      .password_digest(CryptoHelper.hash_bcrypt(password, 4))

    login_1 = LogUserIn.create!(
      params(email: email, password: password),
      session: Lucky::Session.new,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    )

    login_2 = LogUserIn.create!(
      params(email: email, password: password),
      session: Lucky::Session.new,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    )

    current_login = LogUserIn.create!(
      params(email: email, password: password),
      session: Lucky::Session.new,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    )

    login_1.status.started?.should be_true
    login_2.status.started?.should be_true
    current_login.status.started?.should be_true

    UpdateCurrentUser.update!(
      user,
      params(password: new_password, password_confirmation: new_password),
      current_login: current_login
    )

    login_1.reload.status.started?.should be_false
    login_2.reload.status.started?.should be_false
    current_login.reload.status.started?.should be_true
  end
end
