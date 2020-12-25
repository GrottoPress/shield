require "../../../spec_helper"

describe Shield::EmailConfirmations::New do
  it "renders new page" do
    response = ApiClient.exec(EmailConfirmations::New)

    response.body.should eq("EmailConfirmations::NewPage")
  end

  it "requires logged out" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.browser_auth(email, password)

    response = client.exec(EmailConfirmations::New)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("true")
  end
end
