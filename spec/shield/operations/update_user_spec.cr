require "../../spec_helper"

describe Shield::UpdateUser do
  it "updates user" do
    new_email = "newuser@example.tld"
    user = create_user!(email: "user@example.tld")

    UpdateUser.update(
      user,
      params(email: new_email),
      current_login: nil
    ) do |operation, updated_user|
      operation.saved?.should be_true
      updated_user.email.should eq(new_email)
    end
  end

  it "updates user options" do
    new_email = "user@example.com"

    user = create_user!(
      email: "user@domain.tld",
      login_notify: true,
      password_notify: false
    )

    UpdateUser.update(
      user,
      params(login_notify: "false", password_notify: "true", email: new_email),
      current_login: nil
    ) do |operation, updated_user|
      operation.saved?.should be_true

      updated_user.email.should eq(new_email)

      user_options = updated_user.options!
      user_options.login_notify.should be_false
      user_options.password_notify.should be_true
    end
  end

  it "fails when nested operation fails" do
    user = create_current_user!(login_notify: true, password_notify: true)

    UpdateCurrentUser2.update(
      user,
      params(login_notify: false, password_notify: false),
      current_login: nil
    ) do |operation, updated_user|
      operation.saved?.should be_false

      user_options = updated_user.options!
      user_options.login_notify.should be_true
      user_options.password_notify.should be_true
    end
  end

  it "fails when attributes change and nested operation fails" do
    email = "user@domain.tld"

    user = create_current_user!(
      email: email,
      login_notify: true,
      password_notify: true
    )

    UpdateCurrentUser2.update(
      user,
      params(
        email: "user@example.com",
        login_notify: false,
        password_notify: false
      ),
      current_login: nil
    ) do |operation, updated_user|
      operation.saved?.should be_false

      updated_user.email = email
      user_options = updated_user.options!
      user_options.login_notify.should be_true
      user_options.password_notify.should be_true
    end
  end
end
