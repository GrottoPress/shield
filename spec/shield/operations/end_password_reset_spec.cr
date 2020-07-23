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

    password_reset = StartPasswordReset.create!(
      user_email: email,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    )

    EndPasswordReset.update(
      password_reset,
      Avram::Params.new({"status" => "Started"}),
      status: PasswordReset::Status.new(:expired)
    ) do |operation, updated_password_reset|
      operation.saved?.should be_true

      updated_password_reset.ended_at.should_not be_nil
      updated_password_reset.status.expired?.should be_true
    end
  end
end
