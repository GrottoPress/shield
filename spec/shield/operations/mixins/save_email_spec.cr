require "../../../spec_helper"

private class SaveUser < User::SaveOperation
  permit_columns :email, :level, :password_digest

  include Shield::SaveEmail
end

describe Shield::SaveEmail do
  it "saves email" do
    email = "user@exaMple.tlD"

    SaveUser.create(params(
      email: email,
      password_digest: "abc",
      level: "Author"
    )) do |_, user|
      user.should be_a(User)
      user.try &.email.should eq(email)
    end
  end

  it "requires email" do
    SaveUser.create(params(
      password_digest: "abc",
      level: "Author"
    )) do |operation, user|
      user.should be_nil

      assert_invalid(operation.email, "operation.error.email_required")
    end
  end

  it "rejects invalid email" do
    SaveUser.create(params(
        email: "email",
        password_digest: "abc",
        level: "Author"
    )) do |operation, user|
      user.should be_nil

      assert_invalid(operation.email, "operation.error.email_invalid")
    end
  end

  it "rejects existing email" do
    email = "user@example.tld"

    UserFactory.create &.email(email)

    SaveUser.create(params(
      email: email,
      password_digest: "abc",
      level: "Author"
    )) do |operation, user|
      user.should be_nil

      operation.user_email?.should be_true
      assert_invalid(operation.email, "operation.error.email_taken")
    end
  end
end
