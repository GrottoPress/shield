require "../../spec_helper"

describe Shield::UpdateConfirmedEmail do
  it "updates confirmed email" do
    new_email = "user@example.tld"

    user = UserFactory.create &.email("user@domain.com")
    UserOptionsFactory.create &.user_id(user.id)

    session = Lucky::Session.new

    StartEmailConfirmation.create(
      params(email: new_email),
      user_id: user.id,
      remote_ip: Socket::IPAddress.new("1.2.3.4", 5)
    ) do |operation, email_confirmation|
      email_confirmation = email_confirmation.not_nil!

      from_session = EmailConfirmationSession.new(session).set(
        operation,
        email_confirmation
      )

      UpdateConfirmedEmail.update(
        from_session.verify!,
        session: session
      ) do |_operation, updated_email_confirmation|
        _operation.saved?.should be_true

        user.reload.email = new_email

        updated_email_confirmation.status.active?.should be_false
        updated_email_confirmation.success?.should be_true

        from_session.email_confirmation_id?.should be_nil
        from_session.email_confirmation_token?.should be_nil
      end
    end
  end

  it "requires user ID" do
    email_confirmation = EmailConfirmationFactory.create

    UpdateConfirmedEmail.update(
      email_confirmation,
      session: nil
    ) do |operation, _|
      operation.saved?.should be_false
      operation.user_id.should have_error("operation.error.user_id_required")
    end
  end

  it "ends all active email confirmations for that email" do
    email = "user@example.tld"

    user = UserFactory.create &.email("another_user@example.net")
    user_2 = UserFactory.create &.email("yet_another_user@edomain.com")

    UserOptionsFactory.create &.user_id(user.id)
    UserOptionsFactory.create &.user_id(user_2.id)

    email_confirmation = EmailConfirmationFactory.create &.user_id(user.id)
      .email(email)

    email_confirmation_2 = EmailConfirmationFactory.create &.user_id(user.id)
      .email(email)

    email_confirmation_3 = EmailConfirmationFactory.create &.email(email)

    email_confirmation_4 = EmailConfirmationFactory.create &.user_id(user.id)
      .email("abc@domain.com")

    email_confirmation_5 = EmailConfirmationFactory.create &.email(
      "def@domain.com"
    )

    email_confirmation.status.active?.should be_true
    email_confirmation_2.status.active?.should be_true
    email_confirmation_3.status.active?.should be_true
    email_confirmation_4.status.active?.should be_true
    email_confirmation_5.status.active?.should be_true

    UpdateConfirmedEmail.update(
      email_confirmation,
      session: nil
    ) do |operation, updated_email_confirmation|
      operation.saved?.should be_true

      updated_email_confirmation.status.active?.should be_false
      email_confirmation_2.reload.status.active?.should be_false
      email_confirmation_3.reload.status.active?.should be_false
      email_confirmation_4.reload.status.active?.should be_true
      email_confirmation_5.reload.status.active?.should be_true
    end
  end
end
