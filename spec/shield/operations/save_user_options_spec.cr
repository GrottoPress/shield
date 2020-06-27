require "../../spec_helper"

describe Shield::SaveUserOptions do
  it "requires user id" do
    SaveUserOptions.create(
      login_notify: true,
      password_notify: true
    ) do |operation, user_options|
      user_options.should be_nil

      operation
        .user_id
        .errors
        .find(&.includes? " required")
        .should_not(be_nil)
    end
  end

  it "requires login notification option" do
    password = "password1@Upassword"

    user = SaveCurrentUser.create!(
      email: "user@example.tld",
      password: password,
      password_confirmation: password,
      login_notify: true,
      password_notify: true
    )

    SaveUserOptions.create(
      user_id: user.id,
      password_notify: true
    ) do |operation, user_options|
      user_options.should be_nil

      operation
        .login_notify
        .errors
        .find(&.includes? " required")
        .should_not(be_nil)
    end
  end

  it "requires password notification option" do
    password = "password1@Upassword"

    user = SaveCurrentUser.create!(
      email: "user@example.tld",
      password: password,
      password_confirmation: password,
      login_notify: true,
      password_notify: true
    )

    SaveUserOptions.create(
      user_id: user.id,
      login_notify: true
    ) do |operation, user_options|
      user_options.should be_nil

      operation
        .password_notify
        .errors
        .find(&.includes? " required")
        .should_not(be_nil)
    end
  end
end
