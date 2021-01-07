require "../../../spec_helper"

describe Shield::SendWelcomeEmail do
  it "sends welcome email for existing user" do
    email = "user@example.tld"

    UserBox.create &.email(email)

    RegisterCurrentUser.create(
      nested_params(user: {email: email})
    ) do |operation, user|
      user.should be_nil

      UserWelcomeEmail.new(operation).should be_delivered
    end
  end

  it "sends welcome email for new user" do
    params = nested_params(
      user: {
        email: "user@example.tld",
        password: "password12U.password",
        level: User::Level.new(:author)
      },
      user_options: {login_notify: true, password_notify: true}
    )

    RegisterCurrentUser.create(params) do |operation, user|
      UserWelcomeEmail.new(operation).should_not be_delivered
      WelcomeEmail.new(operation, user.not_nil!).should be_delivered
    end
  end
end
