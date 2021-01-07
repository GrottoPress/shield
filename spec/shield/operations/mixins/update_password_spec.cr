require "../../../spec_helper"

describe Shield::UpdatePassword do
  it "updates password" do
    password = "password12U-password"
    new_password = "assword12U-passwor"

    user = UserBox.create &.password_digest(
      BcryptHash.new(password).hash
    )

    UpdateCurrentUser.update!(
      user,
      nested_params(user: {password: new_password}),
      current_login: nil
    )

    BcryptHash.new(new_password)
      .verify?(user.reload.password_digest)
      .should(be_true)
  end

  it "does not update password if new password empty" do
    user = UserBox.create

    UpdateCurrentUser.update(
      user,
      nested_params(user: {password: ""}),
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
      .password_digest(BcryptHash.new(password).hash)

    UpdateCurrentUser.update(
      user,
      nested_params(user: {password: new_password}),
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
      BcryptHash.new(password).hash
    )

    UpdateCurrentUser.update(
      user,
      nested_params(
        user: {password: new_password},
        user_options: {password_notify: false}
      ),
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
      .password_digest(BcryptHash.new(password).hash)

    UpdateCurrentUser.update(
      user,
      nested_params(user: {email: "user2@example.tld", password: password}),
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
      .password_digest(BcryptHash.new(password).hash)

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

    login_1.active?.should be_true
    login_2.active?.should be_true

    UpdateCurrentUser.update!(
      user,
      nested_params(user: {password: new_password}),
      current_login: nil
    )

    login_1.reload.active?.should be_false
    login_2.reload.active?.should be_false
  end

  it "retains current login when password changes" do
    email = "user@example.tld"
    password = "password12U-password"
    new_password = "assword12U-passwor"

    user = UserBox.create &.email(email)
      .password_digest(BcryptHash.new(password).hash)

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

    login_1.active?.should be_true
    login_2.active?.should be_true
    current_login.active?.should be_true

    UpdateCurrentUser.update!(
      user,
      nested_params(user: {password: new_password}),
      current_login: current_login
    )

    login_1.reload.active?.should be_false
    login_2.reload.active?.should be_false
    current_login.reload.active?.should be_true
  end

  it "does not log other users out when password changes" do
    mary_email = "mary@example.tld"
    mary_password = "password12U-password"
    mary_new_password = "assword12U-passwor"

    john_email = "john@example.tld"
    john_password = "pasword12U-pasword"

    mary = UserBox.create &.email(mary_email)
      .password_digest(BcryptHash.new(mary_password).hash)

    john = UserBox.create &.email(john_email)
      .password_digest(BcryptHash.new(john_password).hash)

    mary_login = LogUserIn.create!(
      params(email: mary_email, password: mary_password),
      session: Lucky::Session.new,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    )

    john_login = LogUserIn.create!(
      params(email: john_email, password: john_password),
      session: Lucky::Session.new,
      remote_ip: Socket::IPAddress.new("1.2.3.4", 5)
    )

    mary_login.active?.should be_true
    john_login.active?.should be_true

    UpdateCurrentUser.update!(
      mary,
      nested_params(user: {password: mary_new_password}),
      current_login: nil
    )

    mary_login.reload.active?.should be_false
    john_login.reload.active?.should be_true
  end
end
