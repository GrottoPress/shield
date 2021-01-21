require "../../spec_helper"

describe Shield::UpdateConfirmedEmail do
  it "updates confirmed email" do
    new_email = "user@example.tld"

    user = UserBox.create &.email("user@domain.com")

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
        from_session.verify!.user!.not_nil!,
        email_confirmation: from_session.email_confirmation!,
        session: session
      ) do |operation, updated_user|
        operation.saved?.should be_true

        user.reload.email = new_email

        from_session.email_confirmation_id.should be_nil
        from_session.email_confirmation_token.should be_nil
      end
    end
  end

  it "ends all active email confirmations for that email" do
    email = "user@example.tld"

    user = UserBox.create &.email("another_user@example.net")
    user_2 = UserBox.create &.email("yet_another_user@edomain.com")

    email_confirmation = EmailConfirmationBox.create &.user_id(user.id)
      .email(email)

    email_confirmation_2 = EmailConfirmationBox.create &.user_id(user.id)
      .email(email)

    email_confirmation_3 = EmailConfirmationBox.create &.email(email)

    email_confirmation_4 = EmailConfirmationBox.create &.user_id(user.id)
      .email("abc@domain.com")

    email_confirmation_5 = EmailConfirmationBox.create &.email("def@domain.com")

    email_confirmation.active?.should be_true
    email_confirmation_2.active?.should be_true
    email_confirmation_3.active?.should be_true
    email_confirmation_4.active?.should be_true
    email_confirmation_5.active?.should be_true

    UpdateConfirmedEmail.update!(
      user,
      email_confirmation: email_confirmation,
      session: nil
    )

    email_confirmation.reload.active?.should be_false
    email_confirmation_2.reload.active?.should be_false
    email_confirmation_3.reload.active?.should be_false
    email_confirmation_4.reload.active?.should be_true
    email_confirmation_5.reload.active?.should be_true
  end
end
