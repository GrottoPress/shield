require "../../spec_helper"

describe Shield::RegisterUser do
  it "creates user" do
    password = "password12U password"

    create_user(
      email: "user@example.tld",
      password: password,
      password_confirmation: password,
      level: User::Level.new(:editor)
    ) do |operation, user|
      user.should be_a(User)
    end
  end

  it "creates user options" do
    user = create_user!(login_notify: true, password_notify: false)

    user_options = user.options!

    user_options.login_notify.should be_true
    user_options.password_notify.should be_false
  end

  it "fails when nested operation fails" do
    password = "password12U password"

    RegisterCurrentUser2.create(params(
      email: "user@example.tld",
      password: password,
      password_confirmation: password,
      login_notify: false,
      password_notify: false
    )) do |operation, user|
      operation.saved?.should be_false
    end
  end
end
