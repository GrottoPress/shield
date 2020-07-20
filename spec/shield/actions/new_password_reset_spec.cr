require "../../spec_helper"

describe Shield::NewPasswordReset do
  it "works" do
    response = AppClient.exec(PasswordResets::New)

    body(response)["status"]?.should eq(1)
  end

  it "requires logged out" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    create_current_user!(
      email: email,
      password: password,
      password_confirmation: password
    )

    client = AppClient.new

    response = client.exec(Logins::Create, login: {
      email: email,
      password: password
    })

    body(response)["session"]?.should_not be_nil

    client.headers("Cookie": response.headers["Set-Cookie"])
    response = client.exec(PasswordResets::New)

    body(response)["status"]?.should be_nil
  end
end
