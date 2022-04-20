require "../../../spec_helper"

describe Shield::PasswordResets::Create do
  it "starts password reset" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    user = UserFactory.create &.email(email).password(password)
    UserOptionsFactory.create &.user_id(user.id)

    response = ApiClient.exec(PasswordResets::Create, password_reset: {
      email: email
    })

    response.headers["X-Password-Reset-ID"]?.should eq("pr_id")
  end

  it "succeeds even if email does not exist" do
    email = "user@example.tld"

    response = ApiClient.exec(PasswordResets::Create, password_reset: {
      email: email
    })

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Password-Reset-Status"]?.should eq("success")
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
    response.headers["X-Logged-In"]?.should eq("true")
  end
end
