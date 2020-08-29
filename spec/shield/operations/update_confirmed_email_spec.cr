require "../../spec_helper"

describe Shield::UpdateConfirmedEmail do
  it "updates confirmed email" do
    new_email = "user@example.tld"

    user = create_current_user!(email: "user@domain.com")

    session = Lucky::Session.new

    StartEmailConfirmation.submit(
      params(email: new_email),
      user_id: user.id,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    ) do |operation, email_confirmation|
      from_session = EmailConfirmationSession.new(session).set(operation.token)

      UpdateConfirmedEmail.update(
        from_session.verify!.user!,
        email: from_session.email_confirmation_email!,
        session: session
      ) do |operation, updated_user|
        operation.saved?.should be_true

        user.reload.email = new_email

        from_session.email_confirmation_user_id.should be_nil
        from_session.email_confirmation_email.should be_nil
        from_session.email_confirmation_ip_address.should be_nil
        from_session.email_confirmation_started_at.should be_nil
      end
    end
  end
end
