require "../../spec_helper"

describe Shield::ResetPassword do
  it "resets password" do
    email = "user@example.tld"
    password = "password12U\\password"
    new_password = "assword12U\\passwor"

    UserFactory.create &.email(email).password(password)

    session = Lucky::Session.new

    StartPasswordReset.create(
      params(email: email),
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    ) do |operation, password_reset|
      password_reset = password_reset.not_nil!

      PasswordResetSession.new(session).set(operation, password_reset)

      ResetPassword.update(
        PasswordResetSession.new(session).verify!.user!,
        params(password: new_password),
        session: session,
        current_login: nil
      ) do |operation, updated_user|
        operation.saved?.should be_true

        PasswordAuthentication.new(updated_user)
          .verify(new_password)
          .should(be_a User)

        password_reset.reload.active?.should be_false
        PasswordResetSession.new(session).password_reset_id.should be_nil
        PasswordResetSession.new(session).password_reset_token.should be_nil
      end
    end
  end

  it "requires password" do
    email = "user@example.tld"
    password = "password12U\\password"
    new_password = ""

    user = UserFactory.create &.email(email).password(password)

    ResetPassword.update(
      user,
      params(password: new_password),
      session: Lucky::Session.new,
      current_login: nil
    ) do |operation, updated_user|
      operation.saved?.should be_false

      assert_invalid(operation.password, " required")
    end
  end

  it "ends password reset even if new password equals old" do
    email = "user@example.tld"
    password = "password12U\\password"
    new_password = password

    user = UserFactory.create &.email(email).password(password)
    password_reset = PasswordResetFactory.create &.user_id(user.id)

    ResetPassword.update(
      user,
      params(password: new_password),
      session: Lucky::Session.new,
      current_login: nil
    ) do |operation, updated_user|
      operation.saved?.should be_true

      password_reset.reload.active?.should be_false
    end
  end

  it "ends all active password resets for user" do
    email = "user@example.tld"
    password = "password12U-password"
    new_password = "assword12U-passwor"

    user = UserFactory.create &.email(email).password(password)
    user_2 = UserFactory.create
    password_reset_1 = PasswordResetFactory.create &.user_id(user.id)
    password_reset_2 = PasswordResetFactory.create &.user_id(user.id)
    password_reset_3 = PasswordResetFactory.create &.user_id(user_2.id)

    password_reset_1.active?.should be_true
    password_reset_2.active?.should be_true
    password_reset_3.active?.should be_true

    ResetPassword.update!(
      user,
      params(password: new_password),
      session: Lucky::Session.new,
      current_login: nil
    )

    password_reset_1.reload.active?.should be_false
    password_reset_2.reload.active?.should be_false
    password_reset_3.reload.active?.should be_true
  end
end
