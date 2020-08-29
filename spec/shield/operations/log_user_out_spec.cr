require "../../spec_helper"

describe Shield::LogUserOut do
  it "logs user out" do
    email = "user@example.tld"
    password = "password12U//password"

    create_current_user!(
      email: email,
      password: password,
      password_confirmation: password
    )

    session = Lucky::Session.new

    LogUserIn.create!(
      params(email: email, password: password),
      session: session,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    )

    LoginSession.new(session).login_id.should_not be_nil

    LogUserOut.update(
      LoginSession.new(session).login!,
      params(status: "Expired"),
      status: Login::Status.new(:started),
      session: session
    ) do |operation, updated_login|
      operation.saved?.should be_true

      updated_login.ended_at.should be_a(Time)
      updated_login.status.ended?.should be_true

      LoginSession.new(session).login_id.should be_nil
    end
  end
end
