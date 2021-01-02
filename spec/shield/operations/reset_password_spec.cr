require "../../spec_helper"

describe Shield::ResetPassword do
  it "resets password" do
    email = "user@example.tld"
    password = "password12U\\password"
    new_password = "assword12U\\passwor"

    UserBox.create &.email(email)
      .password_digest(BcryptHash.new(password).hash)

    session = Lucky::Session.new

    StartPasswordReset.create(
      params(email: email),
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    ) do |operation, password_reset|
      password_reset = password_reset.not_nil!

      PasswordResetSession.new(session).set(password_reset, operation)

      ResetPassword.update(
        PasswordResetSession.new(session).verify!.user!,
        params(password: new_password),
        session: session,
        current_login: nil
      ) do |operation, updated_user|
        operation.saved?.should be_true

        UserHelper.verify_user?(updated_user, new_password).should be_true
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

    UserBox.create &.email(email)
      .password_digest(BcryptHash.new(password).hash)

    session = Lucky::Session.new

    password_reset = StartPasswordReset.create!(
      params(email: email),
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    )

    ResetPassword.update(
      password_reset.user!,
      params(password: new_password),
      session: session,
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

    UserBox.create &.email(email)
      .password_digest(BcryptHash.new(password).hash)

    session = Lucky::Session.new

    password_reset = StartPasswordReset.create!(
      params(email: email),
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    )

    ResetPassword.update(
      password_reset.user!,
      params(password: new_password),
      session: session,
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

    UserBox.create &.email(email)
      .password_digest(BcryptHash.new(password).hash)

    session = Lucky::Session.new

    password_reset_1 = StartPasswordReset.create!(
      params(email: email),
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    )

    password_reset_2 = StartPasswordReset.create!(
      params(email: email),
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    )

    password_reset_1.active?.should be_true
    password_reset_2.active?.should be_true

    ResetPassword.update!(
      password_reset_1.user!,
      params(password: new_password),
      session: session,
      current_login: nil
    )

    password_reset_1.reload.active?.should be_false
    password_reset_2.reload.active?.should be_false
  end
end
