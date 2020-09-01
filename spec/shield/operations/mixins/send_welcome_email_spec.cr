require "../../../spec_helper"

describe Shield::SendWelcomeEmail do
  it "sends welcome email for existing user" do
    email = "user@example.tld"
    password = "password12U-password"

    create_user!(
      email: email,
      password: password,
      password_confirmation: password,
      level: User::Level.new(:editor)
    )

    create_current_user(
      email: email,
      password: password,
      password_confirmation: password
    ) do |operation, user|
      user.should be_nil

      UserWelcomeEmail.new(operation).should be_delivered
    end
  end

  it "sends welcome email for new user" do
    password = "password12U.password"

    create_current_user(
      email: "user@example.tld",
      password: password,
      password_confirmation: password
    ) do |operation, user|
      UserWelcomeEmail.new(operation).should_not be_delivered
      WelcomeEmail.new(operation, user.not_nil!).should be_delivered
    end
  end
end
