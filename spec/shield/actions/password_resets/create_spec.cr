require "../../../spec_helper"

describe Shield::PasswordResets::Create do
  it "works" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    UserBox.create &.email(email)
      .password_digest(CryptoHelper.hash_bcrypt(password))

    response = ApiClient.exec(PasswordResets::Create, password_reset: {
      email: email
    })

    response.status.should eq(HTTP::Status::FOUND)
  end

  it "requires logged out" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.browser_auth(email, password)

    response = client.exec(PasswordResets::Create, password_reset: {
      email: email
    })

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"].should eq("true")
  end
end
