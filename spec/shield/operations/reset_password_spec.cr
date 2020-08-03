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

    password_reset = StartPasswordReset.create!(
      email: email,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    )

    ResetPassword.update(
      password_reset.user!,
      password: new_password,
      password_confirmation: new_password,
      password_reset: password_reset,
      current_login: nil
    ) do |operation, updated_user|
      operation.saved?.should be_true

      VerifyLogin.verify_bcrypt?(
        new_password,
        updated_user.password_hash
      ).should be_true

      PasswordResetQuery.find(password_reset.id).status.started?.should be_false
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

    password_reset = StartPasswordReset.create!(
      email: email,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    )

    ResetPassword.update(
      password_reset.user!,
      password: new_password,
      password_confirmation: new_password,
      password_reset: password_reset,
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

    password_reset = StartPasswordReset.create!(
      email: email,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    )

    ResetPassword.update(
      password_reset.user!,
      password: new_password,
      password_confirmation: new_password,
      password_reset: password_reset,
      current_login: nil
    ) do |operation, updated_user|
      operation.saved?.should be_true

      PasswordResetQuery.find(password_reset.id).status.started?.should be_false
    end
  end
end
