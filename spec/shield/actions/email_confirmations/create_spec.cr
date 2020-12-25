require "../../../spec_helper"

describe Shield::EmailConfirmations::Create do
  it "starts email confirmation" do
    response = ApiClient.exec(EmailConfirmations::Create, email_confirmation: {
      email: "user@domain.tld"
    })

    response.headers["X-Email-Confirmation-ID"].should eq("ec_id")
  end

  it "requires logged out" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.browser_auth(email, password)

    response = client.exec(EmailConfirmations::Create, email_confirmation: {
      email: "user@domain.tld"
    })

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"].should eq("true")
  end
end
