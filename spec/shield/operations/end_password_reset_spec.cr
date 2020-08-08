require "../../spec_helper"

describe Shield::EndPasswordReset do
  it "ends password reset" do
    email = "user@example.tld"
    password = "password12U password"

    create_current_user!(
      email: email,
      password: password,
      password_confirmation: password
    )

    session = Lucky::Session.new

    StartPasswordReset.create(
      email: email,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    ) do |operation, password_reset|
      password_reset =  password_reset.not_nil!

      PasswordResetSession.new(session).set(password_reset.id, operation.token)

      EndPasswordReset.update(
        password_reset,
        Avram::Params.new({"status" => "Started"}),
        status: PasswordReset::Status.new(:expired),
        session: session
      ) do |operation, updated_password_reset|
        operation.saved?.should be_true

        updated_password_reset.ended_at.should_not be_nil
        updated_password_reset.status.expired?.should be_true
      end
    end

    PasswordResetSession.new(session).password_reset_id.should be_nil
    PasswordResetSession.new(session).password_reset_token.should be_nil
  end
end
