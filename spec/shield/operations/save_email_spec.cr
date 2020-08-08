require "../../spec_helper"

describe Shield::SaveEmail do
  it "saves email" do
    email = "user@example.tld"
    user = create_current_user!(email: email)

    user.email.should eq(email)
  end

  it "requires email" do
    password = "password1@Upassword"

    RegisterCurrentUser.create(
      email: "",
      password: password,
      password_confirmation: password
    ) do |operation, user|
      user.should be_nil

      assert_invalid(operation.email, " required")
    end
  end

  it "rejects invalid email" do
    password = "password1+Upassword"

    RegisterCurrentUser.create(
      email: "user",
      password: password,
      password_confirmation: password
    ) do |operation, user|
      user.should be_nil

      assert_invalid(operation.email, "format is invalid")
    end
  end

  it "rejects existing email" do
    password = "password1@Upassword"

    params = {
      email: "user@example.tld",
      password: password,
      password_confirmation: password
    }

    create_current_user!(**params)

    RegisterCurrentUser.create(**params) do |operation, user|
      user.should be_nil

      assert_invalid(operation.email, "already taken")
    end
  end
end
