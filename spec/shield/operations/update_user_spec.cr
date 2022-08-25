require "../../spec_helper"

describe Shield::UpdateUser do
  it "updates user" do
    new_email = "newuser@example.tld"

    user = UserFactory.create &.email("user@example.tld")
    UserOptionsFactory.create &.user_id(user.id)

    UpdateUser.update(
      user,
      nested_params(user: {email: new_email}),
      current_login: nil
    ) do |operation, updated_user|
      operation.saved?.should be_true
      updated_user.email.should eq(new_email)
    end
  end

  it "updates user options" do
    new_email = "user@example.com"

    user = UserFactory.create &.email("user@domain.tld")

    UserOptionsFactory.create &.user_id(user.id)
      .login_notify(true)
      .password_notify(false)
      .bearer_login_notify(true)
      .oauth_access_token_notify(false)

    UpdateUser.update(
      user,
      nested_params(
        user: {email: new_email},
        user_options: {
          login_notify: false,
          password_notify: true,
          bearer_login_notify: false,
          oauth_access_token_notify: true
        }
      ),
      current_login: nil
    ) do |operation, updated_user|
      operation.saved?.should be_true

      updated_user.email.should eq(new_email)

      user_options = updated_user.options!

      user_options.login_notify.should be_false
      user_options.password_notify.should be_true
      user_options.bearer_login_notify.should be_false
      user_options.oauth_access_token_notify.should be_true
    end
  end

  it "fails when nested operation fails" do
    user = UserFactory.create

    UserOptionsFactory.create &.user_id(user.id)
      .login_notify(true)
      .password_notify(true)
      .bearer_login_notify(true)
      .oauth_access_token_notify(true)

    UpdateRegularCurrentUser2.update(
      user,
      nested_params(user_options: {
        login_notify: false,
        password_notify: false,
        bearer_login_notify: false,
        oauth_access_token_notify: false
      }),
      current_login: nil
    ) do |operation, updated_user|
      operation.saved?.should be_false

      user_options = updated_user.options!

      user_options.login_notify.should be_true
      user_options.password_notify.should be_true
      user_options.bearer_login_notify.should be_true
      user_options.oauth_access_token_notify.should be_true
    end
  end

  it "fails when attributes change and nested operation fails" do
    email = "user@domain.tld"

    user = UserFactory.create &.email(email)

    UserOptionsFactory.create &.user_id(user.id)
      .login_notify(true)
      .password_notify(true)
      .bearer_login_notify(true)
      .oauth_access_token_notify(true)

    UpdateRegularCurrentUser2.update(
      user,
      nested_params(
        user: {email: "user@example.com"},
        user_options: {
          login_notify: false,
          password_notify: false,
          bearer_login_notify: false,
          oauth_access_token_notify: false
        }
      ),
      current_login: nil
    ) do |operation, updated_user|
      operation.saved?.should be_false

      user_options = updated_user.options!

      user_options.login_notify.should be_true
      user_options.password_notify.should be_true
      user_options.bearer_login_notify.should be_true
      user_options.oauth_access_token_notify.should be_true
    end
  end
end
