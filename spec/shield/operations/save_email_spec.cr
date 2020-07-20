require "../../spec_helper"

describe Shield::SaveEmail do
  it "saves email" do
    email = "user@example.tld"
    user = create_current_user!(email: email)

    user.email.should eq(email)
  end

  it "requires email" do
    password = "password1@Upassword"

    SaveCurrentUser.create(
      email: "",
      password: password,
      password_confirmation: password,
      current_login: nil
    ) do |operation, user|
      user.should be_nil

      operation
        .email
        .errors
        .find(&.includes? " required")
        .should_not(be_nil)
    end
  end

  it "rejects invalid email" do
    password = "password1+Upassword"

    SaveCurrentUser.create(
      email: "user",
      password: password,
      password_confirmation: password,
      current_login: nil
    ) do |operation, user|
      user.should be_nil

      operation
        .email
        .errors
        .find(&.includes? "format invalid")
        .should_not(be_nil)
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

    SaveCurrentUser.create(**params, current_login: nil) do |operation, user|
      user.should be_nil

      operation
        .email
        .errors
        .find(&.includes? "already taken")
        .should_not(be_nil)
    end
  end
end
