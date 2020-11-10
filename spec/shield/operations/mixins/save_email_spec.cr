require "../../../spec_helper"

describe Shield::SaveEmail do
  it "saves email" do
    email = "user@example.tld"

    user = RegisterCurrentUser.create!(params(
      email: email,
      password: "password12U)password",
      login_notify: true,
      password_notify: true
    ))

    user.email.should eq(email)
  end

  it "requires email" do
    RegisterCurrentUser.create(params(email: "")) do |operation, user|
      user.should be_nil

      assert_invalid(operation.email, " required")
    end
  end

  it "rejects invalid email" do
    RegisterCurrentUser.create(params(email: "user")) do |operation, user|
      user.should be_nil

      assert_invalid(operation.email, "format is invalid")
    end
  end

  it "rejects existing email" do
    email = "user@example.tld"

    UserBox.create &.email(email)

    RegisterCurrentUser.create(params(email: email)) do |operation, user|
      user.should be_nil

      operation.user_email?.should be_true
      assert_invalid(operation.email, "already taken")
    end
  end
end
