require "../../spec_helper"

describe Shield::SaveCurrentUser do
  it "saves new user" do
    password = "password12U password"

    create_current_user(
      email: "user@example.tld",
      password: password,
      password_confirmation: password
    ) do |operation, user|
      user.should be_a(User)
    end
  end

  it "updates existing user" do
    new_email = "newuser@example.tld"

    user = create_current_user!(email: "user@example.tld")

    SaveCurrentUser.update(
      user,
      email: new_email,
      current_login: nil
    ) do |operation, updated_user|
      operation.saved?.should be_true
      updated_user.email.should eq(new_email)
    end
  end

  it "saves user options" do
    user = create_current_user!(login_notify: true, password_notify: false)

    user_options = user.options!
    user_options.login_notify.should be_true
    user_options.password_notify.should be_false
  end

  it "updates user options" do
    user = create_current_user!(login_notify: true, password_notify: false)

    params = Avram::Params.new({
      "login_notify" => "false",
      "password_notify" => "true",
      "user_id" => "2222",
    })

    SaveCurrentUser.update(
      user,
      params,
      current_login: nil
    ) do |operation, updated_user|
      user_options = updated_user.options!

      user_options.user_id.should eq(user.id)
      user_options.login_notify.should be_false
      user_options.password_notify.should be_true
    end
  end

  it "fails when nested operation fails" do
    user = create_current_user!(login_notify: true, password_notify: true)

    SaveCurrentUser2.update(
      user,
      login_notify: false,
      password_notify: false,
      current_login: nil
    ) do |operation, updated_user|
      operation.saved?.should be_false

      user_options = updated_user.options!
      user_options.login_notify.should be_true
      user_options.password_notify.should be_true
    end
  end
end
