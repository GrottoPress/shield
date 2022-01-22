require "../../../spec_helper"

private class SaveUser < User::SaveOperation
  permit_columns :email
  attribute password : String

  before_save do
    set_password_digest
  end

  include Shield::ValidateUser

  private def set_password_digest
    password_digest.value = password.value
  end
end

describe Shield::ValidateUser do
  it "requires email" do
    SaveUser.create(params(password: "secret")) do |operation, user|
      user.should be_nil

      operation.email.should have_error("operation.error.email_required")
    end
  end

  it "requires password" do
    SaveUser.create(params(email: "user@example.tld")) do |operation, user|
      user.should be_nil

      operation.password_digest
        .should have_error("operation.error.password_required")
    end
  end

  it "requires valid email format" do
    SaveUser.create(params(
      email: "user",
      password: "secret"
    )) do |operation, user|
      user.should be_nil

      operation.email.should have_error("operation.error.email_invalid")
    end
  end

  it "requires unique email" do
    email = "user@example.tld"

    UserFactory.create &.email(email)

    SaveUser.create(params(
      email: email,
      password: "secret"
    )) do |operation, user|
      user.should be_nil

      operation.email.should have_error("operation.error.email_exists")
    end
  end
end
