require "../../spec_helper"

describe Shield::DeletePasswordResetToken do
  it "deletes password reset token" do
    email = "user@example.tld"
    password = "password12U password"

    SaveCurrentUser.create!(
      email: email,
      password: password,
      password_confirmation: password,
      login_notify: true,
      password_notify: true
    )

    password_reset = SavePasswordReset.create!(user_email: email)

    DeletePasswordResetToken.update(
      password_reset
    ) do |operation, updated_password_reset|
      operation.saved?.should be_true
      updated_password_reset.token_hash.should be_nil
    end
  end
end
