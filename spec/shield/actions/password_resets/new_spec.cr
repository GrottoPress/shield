require "../../../spec_helper"

describe Shield::PasswordResets::New do
  it "works" do
    response = ApiClient.exec(PasswordResets::New)

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

    client = ApiClient.new

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
