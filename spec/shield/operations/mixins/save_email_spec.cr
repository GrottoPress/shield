require "../../../spec_helper"

describe Shield::SaveEmail do
  it "saves email" do
    email = "user@exaMple.tlD"

    user = RegisterRegularCurrentUser.create!(nested_params(
      user: {email: email, password: "password12U)password"},
      user_options: {
        login_notify: true,
        password_notify: true,
        bearer_login_notify: false
      }
    ))

    user.email.should eq(email)
  end

  it "requires email" do
    RegisterRegularCurrentUser.create(
      nested_params(user: {email: ""})
    ) do |operation, user|
      user.should be_nil

      assert_invalid(operation.email, " required")
    end
  end

  it "rejects invalid email" do
    RegisterRegularCurrentUser.create(
      nested_params(user: {email: "user"})
    ) do |operation, user|
      user.should be_nil

      assert_invalid(operation.email, "is invalid")
    end
  end

  it "rejects existing email" do
    email = "user@example.tld"

    UserFactory.create &.email(email)

    RegisterRegularCurrentUser.create(
      nested_params(user: {email: email})
    ) do |operation, user|
      user.should be_nil

      operation.user_email?.should be_true
      assert_invalid(operation.email, "already taken")
    end
  end
end
