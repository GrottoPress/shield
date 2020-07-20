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
      email: email,
      password: password,
      session: session
    )

    LogUserOut.update(
      Login.from_session!(session),
      session: session
    ) do |operation, updated_login|
      operation.saved?.should be_true
      updated_login.ended_at.should be_a(Time)
      session.get?(:login).should be_nil
    end
  end
end
