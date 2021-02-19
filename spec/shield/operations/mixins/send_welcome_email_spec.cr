require "../../../spec_helper"

describe Shield::SendWelcomeEmail do
  it "sends welcome email for existing user" do
    email = "mary@company.com"

    user = UserFactory.create &.email(email)
    email_confirmation = EmailConfirmationFactory.create &.email(email)

    params = nested_params(
      user: {password: "password12U.password"},
      user_options: {
        login_notify: true,
        password_notify: true,
        bearer_login_notify: false
      }
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
    params = nested_params(
      user: {password: "password12U.password"},
      user_options: {
        login_notify: true,
        password_notify: true,
        bearer_login_notify: false
      }
    )

    RegisterCurrentUser.create(
      params,
      email_confirmation: EmailConfirmationFactory.create,
      session: Lucky::Session.new,
    ) do |operation, user|
      UserWelcomeEmail.new(operation).should_not be_delivered
      WelcomeEmail.new(operation, user.not_nil!).should be_delivered
    end
  end
end
