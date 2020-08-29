require "../../spec_helper"

describe Shield::RegisterEmailConfirmationUser do
  it "creates email confirmed user" do
    password = "password12U password"

    RegisterEmailConfirmationCurrentUser.create(
      params(
        password: password,
        password_confirmation: password,
        login_notify: true,
        password_notify: true
      ),
      email: "user@example.tld",
      session: Lucky::Session.new,
    ) do |operation, user|
      user.should be_a(User)
    end
  end

  it "deletes email confirmation session" do
    email = "user@example.tld"
    password = "password12U,password"
    session = Lucky::Session.new

    email_confirmation_session = EmailConfirmationSession.new(session).set(
      1,
      email,
      Socket::IPAddress.new("128.0.0.2", 5000),
      Time.utc
    )

    RegisterEmailConfirmationCurrentUser.create!(
      params(
        password: password,
        password_confirmation: password,
        login_notify: true,
        password_notify: true
      ),
      email: email,
      session: session,
    )

    email_confirmation_session.email_confirmation_user_id.should be_nil
    email_confirmation_session.email_confirmation_email.should be_nil
    email_confirmation_session.email_confirmation_ip_address.should be_nil
    email_confirmation_session.email_confirmation_started_at.should be_nil
  end

  it "creates user options" do
    password = "password12U-password"

    user = RegisterEmailConfirmationCurrentUser.create!(
      params(
        password: password,
        password_confirmation: password,
        login_notify: true,
        password_notify: false
      ),
      email: "user@example.tld",
      session: Lucky::Session.new,
    )

    user_options = user.options!

    user_options.login_notify.should be_true
    user_options.password_notify.should be_false
  end

  it "fails when nested operation fails" do
    password = "password12U password"

    RegisterEmailConfirmationCurrentUser2.create(
      params(
        password: password,
        password_confirmation: password,
        login_notify: false,
        password_notify: false
      ),
      email: "user@example.tld",
      session: Lucky::Session.new,
    ) do |operation, user|
      operation.saved?.should be_false
    end
  end
end
