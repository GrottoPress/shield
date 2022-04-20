require "../../../spec_helper"

describe Shield::PasswordResets::New do
  it "renders new page" do
    response = ApiClient.exec(PasswordResets::New)

    response.body.should eq("PasswordResets::NewPage")
  end

  it "requires logged out" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.browser_auth(email, password)

    response = client.exec(PasswordResets::New)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("true")
  end
end
