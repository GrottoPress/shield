require "../../spec_helper"

describe Shield::SaveCurrentUser do
  it "requires login notification option" do
    password = "password1@Upassword"

    SaveCurrentUser.create(
      email: "user@example.tld",
      password: password,
      password_confirmation: password,
      password_notify: true
    ) do |operation, user|
      user.should be_nil

      operation
        .login_notify
        .errors
        .find(&.includes? " required")
        .should_not(be_nil)
    end
  end

  it "requires password notification option" do
    password = "password1@Upassword"

    SaveCurrentUser.create(
      email: "user@example.tld",
      password: password,
      password_confirmation: password,
      login_notify: true
    ) do |operation, user|
      user.should be_nil

      operation
        .password_notify
        .errors
        .find(&.includes? " required")
        .should_not(be_nil)
    end
  end

  it "saves new user" do
    password = "password12U password"

    SaveCurrentUser.create(
      email: "user@example.tld",
      password: password,
      password_confirmation: password,
      login_notify: true,
      password_notify: true
    ) do |operation, user|
      user.should be_a(User)
    end
  end

  it "updates existing user" do
    password = "password12U password"

    user = SaveCurrentUser.create!(
      email: "user@example.tld",
      password: password,
      password_confirmation: password,
      login_notify: true,
      password_notify: true
    )

    new_email = "newuser@example.tld"

    SaveCurrentUser.update(user, email: new_email) do |operation, updated_user|
      operation.saved?.should be_true
      updated_user.email.should eq(new_email)
    end
  end

  it "saves user options" do
    password = "password12U>password"

    user = SaveCurrentUser.create!(
      email: "user@example.tld",
      password: password,
      password_confirmation: password,
      login_notify: true,
      password_notify: false
    )

    user_options = user.options!

    user_options.login_notify.should be_true
    user_options.password_notify.should be_false
  end

  it "updates user options" do
    password = "password12U.password"

    user = SaveCurrentUser.create!(
      email: "user@example.tld",
      password: password,
      password_confirmation: password,
      login_notify: true,
      password_notify: false
    )

    SaveCurrentUser.update(
      user,
      login_notify: false,
      password_notify: true
    ) do |operation, updated_user|
      user_options = updated_user.options!

      user_options.login_notify.should be_false
      user_options.password_notify.should be_true
    end
  end
end
