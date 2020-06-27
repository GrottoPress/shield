require "../../spec_helper"

describe Shield::SavePasswordReset do
  it "saves password reset" do
    email = "user@example.tld"
    password = "password12U password"

    user = SaveCurrentUser.create!(
      email: email,
      password: password,
      password_confirmation: password,
      login_notify: true,
      password_notify: true
    )

    SavePasswordReset.create(user_email: email) do |operation, password_reset|
      password_reset.should be_a(PasswordReset)
      operation.token.should_not be_empty
      password_reset.try &.token_hash.should_not(be_nil)
      password_reset.try &.user_id.should(eq user.id)
    end
  end

  it "rejects invalid email" do
    SavePasswordReset.create(user_email: "email") do |operation, password_reset|
      password_reset.should be_nil

      operation
        .user_email
        .errors
        .find(&.includes? "format invalid")
        .should_not(be_nil)
    end
  end

  it "sends guest email" do
    SavePasswordReset.create(
      user_email: "user@example.tld"
    ) do |operation, password_reset|
      password_reset.should be_nil
      GuestPasswordResetRequestEmail.new(operation).should be_delivered
    end
  end

  it "sends password reset request email" do
    email = "user@example.tld"
    password = "password12U password"

    user = SaveCurrentUser.create!(
      email: email,
      password: password,
      password_confirmation: password,
      login_notify: true,
      password_notify: true
    )

    SavePasswordReset.create(user_email: email) do |operation, password_reset|
      GuestPasswordResetRequestEmail.new(operation).should_not be_delivered

      PasswordResetRequestEmail
        .new(operation, password_reset.not_nil!)
        .should(be_delivered)
    end
  end
end
