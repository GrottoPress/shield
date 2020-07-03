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

    password_reset = SavePasswordReset.create!(user_email: email)

    ResetPassword.update(
      password_reset.user!,
      password: new_password,
      password_confirmation: new_password,
      password_reset: password_reset
    ) do |operation, updated_user|
      operation.saved?.should be_true

      Login.verify?(new_password, updated_user.password_hash).should be_true
      PasswordResetQuery.find(password_reset.id).token_hash.should be_nil
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

    password_reset = SavePasswordReset.create!(user_email: email)

    ResetPassword.update(
      password_reset.user!,
      password: new_password,
      password_confirmation: new_password,
      password_reset: password_reset
    ) do |operation, updated_user|
      operation.saved?.should be_false

      operation
        .password
        .errors
        .find(&.includes? " required")
        .should_not(be_nil)
    end
  end

  it "deletes password reset token even if new password equals old" do
    email = "user@example.tld"
    password = "password12U\\password"
    new_password = password

    create_current_user!(
      email: email,
      password: password,
      password_confirmation: password
    )

    password_reset = SavePasswordReset.create!(user_email: email)

    ResetPassword.update(
      password_reset.user!,
      password: new_password,
      password_confirmation: new_password,
      password_reset: password_reset
    ) do |operation, updated_user|
      operation.saved?.should be_true

      PasswordResetQuery.find(password_reset.id).token_hash.should be_nil
    end
  end
end
