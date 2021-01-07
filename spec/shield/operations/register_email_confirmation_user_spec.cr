require "../../spec_helper"

describe Shield::RegisterEmailConfirmationUser do
  it "creates email confirmed user" do
    email_confirmation = StartEmailConfirmation.create!(
      params(email: "user@example.tld"),
      remote_ip: Socket::IPAddress.new("1.2.3.4", 5)
    )

    params = nested_params(
      user: {password: "password12U password"},
      user_options: {login_notify: true, password_notify: true}
    )

    RegisterEmailConfirmationCurrentUser.create(
      params,
      email_confirmation: email_confirmation,
      session: Lucky::Session.new,
    ) do |operation, user|
      user.should be_a(User)

      user.try(&.email).should eq(email_confirmation.email)
      email_confirmation.reload.user_id.should eq(user.try(&.id))
    end
  end

  it "ends all active email confirmations for that email" do
    email = "user@example.tld"

    email_confirmation = StartEmailConfirmation.create!(
      params(email: email),
      remote_ip: Socket::IPAddress.new("1.2.3.4", 5)
    )

    email_confirmation_2 = StartEmailConfirmation.create!(
      params(email: email),
      remote_ip: Socket::IPAddress.new("6.7.8.9", 10)
    )

    email_confirmation_3 = StartEmailConfirmation.create!(
      params(email: "abc@domain.net"),
      remote_ip: Socket::IPAddress.new("11.12.13.14", 15)
    )

    email_confirmation.active?.should be_true
    email_confirmation_2.active?.should be_true
    email_confirmation_3.active?.should be_true

    user = RegisterEmailConfirmationCurrentUser.create!(
      nested_params(
        user: {password: "password12U-password"},
        user_options: {login_notify: true, password_notify: true}
      ),
      email_confirmation: email_confirmation,
    )

    email_confirmation.reload.active?.should be_false
    email_confirmation_2.reload.active?.should be_false
    email_confirmation_3.reload.active?.should be_true

    email_confirmation.reload.user_id.should eq(user.id)
    email_confirmation_2.reload.user_id.should be_nil
    email_confirmation_3.reload.user_id.should be_nil
  end

  it "creates user options" do
    email_confirmation = StartEmailConfirmation.create!(
      params(email: "user@example.tld"),
      remote_ip: Socket::IPAddress.new("1.2.3.4", 5)
    )

    user = RegisterEmailConfirmationCurrentUser.create!(
      nested_params(
        user: {password: "password12U-password"},
        user_options: {login_notify: true, password_notify: false}
      ),
      email_confirmation: email_confirmation,
      session: Lucky::Session.new,
    )

    user_options = user.options!

    user_options.login_notify.should be_true
    user_options.password_notify.should be_false
  end

  it "fails when nested operation fails" do
    email_confirmation = StartEmailConfirmation.create!(
      params(email: "user@example.tld"),
      remote_ip: Socket::IPAddress.new("1.2.3.4", 5)
    )

    RegisterEmailConfirmationCurrentUser2.create(
      nested_params(
        user: {password: "password12U password"},
        user_options: {login_notify: false, password_notify: false}
      ),
      email_confirmation: email_confirmation,
      session: Lucky::Session.new,
    ) do |operation, user|
      operation.saved?.should be_false
    end
  end
end
