require "../../spec_helper"

describe Shield::RegisterEmailConfirmationUser do
  it "creates email confirmed user" do
    email_confirmation = EmailConfirmationFactory.create

    params = nested_params(
      user: {password: "password12U password"},
      user_options: {
        login_notify: true,
        password_notify: true,
        bearer_login_notify: true
      }
    )

    RegisterCurrentUser.create(
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

    email_confirmation = EmailConfirmationFactory.create &.email(email)
    email_confirmation_2 = EmailConfirmationFactory.create &.email(email)
    email_confirmation_3 = EmailConfirmationFactory.create &.email("abc@domain.net")

    email_confirmation.status.active?.should be_true
    email_confirmation_2.status.active?.should be_true
    email_confirmation_3.status.active?.should be_true

    email_confirmation.user_id.should be_nil
    email_confirmation_2.user_id.should be_nil
    email_confirmation_3.user_id.should be_nil

    user = RegisterCurrentUser.create!(
      nested_params(
        user: {password: "password12U-password"},
        user_options: {
          login_notify: true,
          password_notify: true,
          bearer_login_notify: true
        }
      ),
      email_confirmation: email_confirmation,
      session: nil
    )

    email_confirmation = email_confirmation.reload
    email_confirmation_2 = email_confirmation_2.reload
    email_confirmation_3 = email_confirmation_3.reload

    email_confirmation.status.active?.should be_false
    email_confirmation_2.status.active?.should be_false
    email_confirmation_3.status.active?.should be_true

    email_confirmation.user_id.should eq(user.id)
    email_confirmation_2.user_id.should be_nil
    email_confirmation_3.user_id.should be_nil
  end

  it "creates user options" do
    user = RegisterCurrentUser.create!(
      nested_params(
        user: {password: "password12U-password"},
        user_options: {
          login_notify: true,
          password_notify: false,
          bearer_login_notify: true
        }
      ),
      email_confirmation: EmailConfirmationFactory.create,
      session: Lucky::Session.new,
    )

    user_options = user.options!

    user_options.login_notify.should be_true
    user_options.password_notify.should be_false
  end

  it "fails when nested operation fails" do
    RegisterCurrentUser2.create(
      nested_params(
        user: {password: "password12U password"},
        user_options: {
          login_notify: false,
          password_notify: false,
          bearer_login_notify: true
        }
      ),
      email_confirmation: EmailConfirmationFactory.create,
      session: Lucky::Session.new,
    ) do |operation, user|
      operation.saved?.should be_false
    end
  end
end
