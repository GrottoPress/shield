require "../../spec_helper"

describe Shield::UpdateEmailConfirmationUser do
  it "updates user" do
    email = "user@example.tld"
    new_email = "user@domain.com"

    user = UserFactory.create &.email(email)
    UserOptionsFactory.create &.user_id(user.id)

    UpdateCurrentUser.update(
      user,
      nested_params(user: {email: new_email}),
      current_login: nil,
      remote_ip: Socket::IPAddress.new("129.0.0.3", 5555)
    ) do |operation, updated_user|
      operation.saved?.should be_true

      operation.new_email.should eq(new_email)
      updated_user.email.should eq(email)

      operation.email_confirmation.should be_a(EmailConfirmation)
      operation.start_email_confirmation.should be_a(StartEmailConfirmation)

      EmailConfirmationRequestEmail.new(
        operation.start_email_confirmation.not_nil!,
        operation.email_confirmation.not_nil!
      ).should(be_delivered)
    end
  end

  it "updates user options" do
    user = UserFactory.create

    user_options = UserOptionsFactory.create &.user_id(user.id)
      .login_notify(true)
      .password_notify(false)
      .bearer_login_notify(true)
      .oauth_access_token_notify(false)

    UpdateCurrentUser.update(
      user,
      nested_params(user_options: {
        login_notify: false,
        password_notify: true,
        bearer_login_notify: false,
        oauth_access_token_notify: true
      }),
      current_login: nil,
      remote_ip: Socket::IPAddress.new("129.0.0.3", 5555)
    ) do |operation, updated_user|
      operation.saved?.should be_true

      user_options = updated_user.options!

      user_options.login_notify.should be_false
      user_options.password_notify.should be_true
      user_options.bearer_login_notify.should be_false
      user_options.oauth_access_token_notify.should be_true
    end
  end

  it "fails when nested operation fails" do
    user = UserFactory.create

    user_options = UserOptionsFactory.create &.user_id(user.id)
      .login_notify(true)
      .password_notify(true)
      .bearer_login_notify(true)
      .oauth_access_token_notify(true)

    UpdateCurrentUser2.update(
      user,
      nested_params(user_options: {
        login_notify: false,
        password_notify: false,
        bearer_login_notify: false,
        oauth_access_token_notify: false
      }),
      current_login: nil,
      remote_ip: Socket::IPAddress.new("129.0.0.3", 5555)
    ) do |operation, updated_user|
      operation.saved?.should be_false

      user_options = updated_user.options!
      user_options.login_notify.should be_true
      user_options.password_notify.should be_true
    end
  end

  it "fails when attributes change and nested operation fails" do
    password = "password12U-password"
    new_password = "assword12U-passwor"

    user = UserFactory.create &.password(password)

    user_options = UserOptionsFactory.create &.user_id(user.id)
      .login_notify(true)
      .password_notify(true)
      .bearer_login_notify(true)
      .oauth_access_token_notify(true)

    UpdateCurrentUser2.update(
      user,
      nested_params(
        user: {password: new_password},
        user_options: {
          login_notify: false,
          password_notify: false,
          bearer_login_notify: false,
          oauth_access_token_notify: false
        }
      ),
      current_login: nil,
      remote_ip: Socket::IPAddress.new("129.0.0.3", 5555)
    ) do |operation, updated_user|
      operation.saved?.should be_false

      user_options = updated_user.options!
      user_options.login_notify.should be_true
      user_options.password_notify.should be_true
    end
  end
end
