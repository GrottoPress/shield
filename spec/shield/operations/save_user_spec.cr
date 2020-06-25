require "../../spec_helper"

describe Shield::SaveUser do
  it "saves new user" do
    password = "password12U password"

    SaveUser.create(
      email: "user@example.tld",
      password: password,
      password_confirmation: password,
      level: User::Level.new(:editor)
    ) do |operation, user|
      user.should be_a(User)
    end
  end

  it "updates existing user" do
    password = "password12U password"

    user = SaveUser.create!(
      email: "user@example.tld",
      password: password,
      password_confirmation: password,
      level: User::Level.new(:editor)
    )

    new_email = "newuser@example.tld"

    SaveUser.update(user, email: new_email) do |operation, updated_user|
      operation.saved?.should be_true
      updated_user.email.should eq(new_email)
    end
  end
end
