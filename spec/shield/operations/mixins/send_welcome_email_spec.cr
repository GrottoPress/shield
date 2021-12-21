require "../../../spec_helper"

private class SaveUser < User::SaveOperation
  permit_columns :email, :level, :password_digest

  include Shield::SetUserEmail

  before_save do
    validate_email_unique
  end

  include Shield::SendWelcomeEmail

  private def validate_email_unique
    return unless email.value
    email.add_error("exists") if user_email?
  end
end

describe Shield::SendWelcomeEmail do
  it "sends welcome email" do
    SaveUser.create(params(
      email: "abc@def.ghi",
      password_digest: "abc",
      level: "Author"
    )) do |operation, user|
      user.should be_a(User)

      UserWelcomeEmail.new(operation).should_not be_delivered
      WelcomeEmail.new(operation, user.not_nil!).should be_delivered
    end
  end

  it "sends welcome email if user already exists" do
    email = "user@example.tld"

    UserFactory.create &.email(email)

    SaveUser.create(params(
      email: email,
      password_digest: "abc",
      level: "Author"
    )) do |operation, user|
      user.should be_nil

      UserWelcomeEmail.new(operation).should be_delivered
    end
  end
end
