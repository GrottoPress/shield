require "../../../spec_helper"

describe Shield::PasswordResets::Create do
  it "starts password reset" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    UserBox.create &.email(email)
      .password_digest(BcryptHash.new(password).hash)

    response = ApiClient.exec(PasswordResets::Create, password_reset: {
      email: email
    })

    response.headers["X-Password-Reset-ID"].should eq("pr_id")
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
