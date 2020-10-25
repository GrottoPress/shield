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
        email_confirmation,
        operation
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

    email_confirmation = StartEmailConfirmation.create!(
      params(email: email),
      user_id: user.id,
      remote_ip: Socket::IPAddress.new("1.2.3.4", 5)
    )

    email_confirmation_2 = StartEmailConfirmation.create!(
      params(email: email),
      user_id: user_2.id,
      remote_ip: Socket::IPAddress.new("6.7.8.9", 10)
    )

    email_confirmation_3 = StartEmailConfirmation.create!(
      params(email: email),
      remote_ip: Socket::IPAddress.new("11.12.13.14", 15)
    )

    email_confirmation_4 = StartEmailConfirmation.create!(
      params(email: "abc@domain.com"),
      user_id: user.id,
      remote_ip: Socket::IPAddress.new("16.17.18.19", 20)
    )

    email_confirmation_5 = StartEmailConfirmation.create!(
      params(email: "def@domain.com"),
      remote_ip: Socket::IPAddress.new("21.22.23.24", 25)
    )

    email_confirmation.active?.should be_true
    email_confirmation_2.active?.should be_true
    email_confirmation_3.active?.should be_true
    email_confirmation_4.active?.should be_true
    email_confirmation_5.active?.should be_true

    UpdateConfirmedEmail.update!(user, email_confirmation: email_confirmation)

    email_confirmation.reload.active?.should be_false
    email_confirmation_2.reload.active?.should be_false
    email_confirmation_3.reload.active?.should be_false
    email_confirmation_4.reload.active?.should be_true
    email_confirmation_5.reload.active?.should be_true
  end
end
