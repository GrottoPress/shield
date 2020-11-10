require "../../spec_helper"

describe Shield::RegisterUser do
  it "creates user" do
    RegisterUser.create(params(
      email: "user@example.tld",
      password: "password12U password",
      level: User::Level.new(:editor),
      login_notify: true,
      password_notify: true
    )) do |operation, user|
      user.should be_a(User)
    end
  end

  it "creates user options" do
    user = RegisterUser.create!(params(
      email: "user@example.tld",
      password: "password12U/password",
      level: User::Level.new(:editor),
      login_notify: true,
      password_notify: false
    ))

    user_options = user.options!

    user_options.login_notify.should be_true
    user_options.password_notify.should be_false
  end

  it "fails when nested operation fails" do
    RegisterCurrentUser2.create(params(
      email: "user@example.tld",
      password: "password12U password",
      login_notify: false,
      password_notify: false
    )) do |operation, user|
      operation.saved?.should be_false
    end
  end
end
