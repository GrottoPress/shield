require "../../../spec_helper"

describe Shield::UpdatePassword do
  it "saves password" do
    password = "password12U-password"

    user = create_current_user!(
      email: "user@example.tld",
      password: password,
      password_confirmation: password
    )

    VerifyLogin.verify_bcrypt?(password, user.password_hash).should be_true
  end

  it "does not update password if new password empty" do
    user = create_current_user!

    UpdateCurrentUser.update(
      user,
      password: "",
      password_confirmation: "",
      current_login: nil
    ) do |operation, updated_user|
      operation.saved?.should be_true
      updated_user.password_hash.should eq(user.password_hash)
    end
  end

  it "sends password change notification" do
    password = "pass)word1Apassword"
    new_password = "ass)word1Apasswor"

    user = create_current_user!(
      password: password,
      password_confirmation: password,
      password_notify: "1"
    )

    UpdateCurrentUser.update(
      user,
      password: new_password,
      password_confirmation: new_password,
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

    user = create_current_user!(
      password: password,
      password_confirmation: password,
      password_notify: "0"
    )

    UpdateCurrentUser.update(
      user,
      password: new_password,
      password_confirmation: new_password,
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

    user = create_current_user!(
      password: password,
      password_confirmation: password,
      password_notify: "1"
    )

    UpdateCurrentUser.update(
      user,
      email: "user2@example.tld",
      password: password,
      password_confirmation: password,
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

    user = create_current_user!(
      email: email,
      password: password,
      password_confirmation: password
    )

    login_1 = LogUserIn.create!(
      email: email,
      password: password,
      session: Lucky::Session.new,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    )

    login_2 = LogUserIn.create!(
      email: email,
      password: password,
      session: Lucky::Session.new,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    )

    login_1.status.started?.should be_true
    login_2.status.started?.should be_true

    UpdateCurrentUser.update!(
      user,
      password: new_password,
      password_confirmation: new_password,
      current_login: nil
    )

    login_1.reload.status.started?.should be_false
    login_2.reload.status.started?.should be_false
  end

  it "retains current login when password changes" do
    email = "user@example.tld"
    password = "password12U-password"
    new_password = "assword12U-passwor"

    user = create_current_user!(
      email: email,
      password: password,
      password_confirmation: password
    )

    login_1 = LogUserIn.create!(
      email: email,
      password: password,
      session: Lucky::Session.new,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    )

    login_2 = LogUserIn.create!(
      email: email,
      password: password,
      session: Lucky::Session.new,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    )

    current_login = LogUserIn.create!(
      email: email,
      password: password,
      session: Lucky::Session.new,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    )

    login_1.status.started?.should be_true
    login_2.status.started?.should be_true
    current_login.status.started?.should be_true

    UpdateCurrentUser.update!(
      user,
      password: new_password,
      password_confirmation: new_password,
      current_login: current_login
    )

    login_1.reload.status.started?.should be_false
    login_2.reload.status.started?.should be_false
    current_login.reload.status.started?.should be_true
  end
end
