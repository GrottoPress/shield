require "../../../spec_helper"

describe Shield::UpdatePassword do
  it "updates password" do
    password = "password12U-password"
    new_password = "assword12U-passwor"

    user = UserFactory.create &.password(password)
    UserOptionsFactory.create &.user_id(user.id)

    UpdateRegularCurrentUser.update!(
      user,
      nested_params(user: {password: new_password}),
      current_login: nil
    )

    BcryptHash.new(new_password)
      .verify?(user.reload.password_digest)
      .should(be_true)
  end

  it "does not update password if new password empty" do
    user = UserFactory.create
    UserOptionsFactory.create &.user_id(user.id)

    UpdateRegularCurrentUser.update(
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

    user = UserFactory.create &.password(password)
    UserOptionsFactory.create &.user_id(user.id).password_notify(true)

    UpdateRegularCurrentUser.update(
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

    user = UserFactory.create &.password(password)
    UserOptionsFactory.create &.user_id(user.id)

    UpdateRegularCurrentUser.update(
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

    user = UserFactory.create &.password(password)
    UserOptionsFactory.create &.user_id(user.id).password_notify(true)

    UpdateRegularCurrentUser.update(
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

    user = UserFactory.create &.email(email).password(password)
    UserOptionsFactory.create &.user_id(user.id)

    login_1 = LoginFactory.create &.user_id(user.id)
    login_2 = LoginFactory.create &.user_id(user.id)

    login_1.active?.should be_true
    login_2.active?.should be_true

    UpdateRegularCurrentUser.update!(
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

    user = UserFactory.create &.email(email).password(password)
    UserOptionsFactory.create &.user_id(user.id)

    login_1 = LoginFactory.create &.user_id(user.id)
    login_2 = LoginFactory.create &.user_id(user.id)
    current_login = LoginFactory.create &.user_id(user.id)

    login_1.active?.should be_true
    login_2.active?.should be_true
    current_login.active?.should be_true

    UpdateRegularCurrentUser.update!(
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

    mary = UserFactory.create &.email(mary_email).password(mary_password)
    UserOptionsFactory.create &.user_id(mary.id)

    john = UserFactory.create &.email(john_email).password(john_password)
    UserOptionsFactory.create &.user_id(john.id)

    mary_login = LoginFactory.create &.user_id(mary.id)
    john_login = LoginFactory.create &.user_id(john.id)

    mary_login.active?.should be_true
    john_login.active?.should be_true

    UpdateRegularCurrentUser.update!(
      mary,
      nested_params(user: {password: mary_new_password}),
      current_login: nil
    )

    mary_login.reload.active?.should be_false
    john_login.reload.active?.should be_true
  end
end
