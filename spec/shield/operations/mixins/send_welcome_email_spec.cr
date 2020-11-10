require "../../../spec_helper"

describe Shield::SendWelcomeEmail do
  it "sends welcome email for existing user" do
    email = "user@example.tld"

    UserBox.create &.email(email)

    RegisterCurrentUser.create(params(email: email)) do |operation, user|
      user.should be_nil

      UserWelcomeEmail.new(operation).should be_delivered
    end
  end

  it "sends welcome email for new user" do
    RegisterCurrentUser.create(params(
      email: "user@example.tld",
      password: "password12U.password",
      level: User::Level.new(:author),
      login_notify: true,
      password_notify: true
    )) do |operation, user|
      UserWelcomeEmail.new(operation).should_not be_delivered
      WelcomeEmail.new(operation, user.not_nil!).should be_delivered
    end
  end
end
