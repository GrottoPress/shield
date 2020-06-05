require "../../spec_helper"

describe Shield::SaveCurrentUser do
  it "saves new user" do
    password = "password12U password"

    params = {
      email: "user@example.tld",
      password: password,
      password_confirmation: password
    }

    SaveCurrentUser.create(**params) do |operation, user|
      user.should be_a(User)
    end
  end

  it "updates existing user" do
    password = "password12U password"

    params = {
      email: "user@example.tld",
      password: password,
      password_confirmation: password
    }

    SaveCurrentUser.create(**params) do |operation, user|
      user.should be_a(User)

      email = "newuser@example.tld"

      SaveCurrentUser.update(
        user.not_nil!,
        email: email
      ) do |operation, updated_user|
        operation.saved?.should be_true
        updated_user.email.should eq(email)
      end
    end
  end
end
