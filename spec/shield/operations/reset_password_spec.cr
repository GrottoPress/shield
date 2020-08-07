require "../../spec_helper"

describe Shield::ResetPassword do
  it "resets password" do
    email = "user@example.tld"
    password = "password12U\\password"
    new_password = "assword12U\\passwor"

    create_current_user!(
      email: email,
      password: password,
      password_confirmation: password
    )

    session = Lucky::Session.new

    StartPasswordReset.create(
      email: email,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    ) do |operation, password_reset|
      password_reset = password_reset.not_nil!

      PasswordResetSession.new(session).set(password_reset.id, operation.token)

      ResetPassword.update(
        PasswordResetSession.new(session).verify!.user!,
        password: new_password,
        password_confirmation: new_password,
        session: session,
        current_login: nil
      ) do |operation, updated_user|
        operation.saved?.should be_true

        UserHelper.verify_user?(updated_user, new_password).should be_true
        password_reset.reload.status.ended?.should be_true
        PasswordResetSession.new(session).password_reset_id.should be_nil
        PasswordResetSession.new(session).password_reset_token.should be_nil
      end
    end
  end

  it "requires password" do
    email = "user@example.tld"
    password = "password12U\\password"
    new_password = ""

    create_current_user!(
      email: email,
      password: password,
      password_confirmation: password
    )

    session = Lucky::Session.new

    password_reset = StartPasswordReset.create!(
      email: email,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    )

    ResetPassword.update(
      password_reset.user!,
      password: new_password,
      password_confirmation: new_password,
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

    create_current_user!(
      email: email,
      password: password,
      password_confirmation: password
    )

    session = Lucky::Session.new

    password_reset = StartPasswordReset.create!(
      email: email,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    )

    ResetPassword.update(
      password_reset.user!,
      password: new_password,
      password_confirmation: new_password,
      session: session,
      current_login: nil
    ) do |operation, updated_user|
      operation.saved?.should be_true

      password_reset.reload.status.started?.should be_false
    end
  end

  it "ends all active password resets for user" do
    email = "user@example.tld"
    password = "password12U-password"
    new_password = "assword12U-passwor"

    user = create_current_user!(
      email: email,
      password: password,
      password_confirmation: password
    )

    session = Lucky::Session.new

    password_reset_1 = StartPasswordReset.create!(
      email: email,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    )

    password_reset_2 = StartPasswordReset.create!(
      email: email,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    )

    password_reset_1.status.started?.should be_true
    password_reset_2.status.started?.should be_true

    ResetPassword.update!(
      password_reset_1.user!,
      password: new_password,
      password_confirmation: new_password,
      session: session,
      current_login: nil
    )

    password_reset_1.reload.status.started?.should be_false
    password_reset_2.reload.status.started?.should be_false
  end
end
