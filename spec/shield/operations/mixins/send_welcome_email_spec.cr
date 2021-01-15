require "../../../spec_helper"

describe Shield::SendWelcomeEmail do
  it "sends welcome email for existing user" do
    email = "mary@company.com"

    email_confirmation = StartEmailConfirmation.create!(
      params(email: email),
      remote_ip: Socket::IPAddress.new("1.2.3.4", 5)
    )

    user = UserBox.create &.email(email)

    params = nested_params(
      user: {password: "password12U.password"},
      user_options: {login_notify: true, password_notify: true}
    )

    RegisterCurrentUser.create(
      params,
      email_confirmation: email_confirmation,
      session: Lucky::Session.new,
    ) do |operation, user|
      user.should be_nil

      UserWelcomeEmail.new(operation).should be_delivered
    end
  end

  it "sends welcome email for new user" do
    email_confirmation = StartEmailConfirmation.create!(
      params(email: "user@example.tld"),
      remote_ip: Socket::IPAddress.new("1.2.3.4", 5)
    )

    params = nested_params(
      user: {password: "password12U.password"},
      user_options: {login_notify: true, password_notify: true}
    )

    RegisterCurrentUser.create(
      params,
      email_confirmation: email_confirmation,
      session: Lucky::Session.new,
    ) do |operation, user|
      UserWelcomeEmail.new(operation).should_not be_delivered
      WelcomeEmail.new(operation, user.not_nil!).should be_delivered
    end
  end
end
