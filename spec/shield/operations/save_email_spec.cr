require "../../spec_helper"

describe Shield::SaveEmail do
  it "requires email" do
    password = "password1@Upassword"

    params = {
      email: "",
      password: password,
      password_confirmation: password
    }

    SaveCurrentUser.create(**params) do |operation, user|
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

    params = {
      email: "user",
      password: password,
      password_confirmation: password
    }

    SaveCurrentUser.create(**params) do |operation, user|
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

    user = SaveCurrentUser.create!(**params)

    SaveCurrentUser.create(**params) do |operation, user|
      user.should be_nil

      operation
        .email
        .errors
        .find(&.includes? "already taken")
        .should_not(be_nil)
    end
  end
end
