require "../../../spec_helper"

describe Shield::Users::New do
  it "renders edit page" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.browser_auth(email, password)

    response = client.exec(Users::New)

    response.body.should eq("Users::NewPage")
  end

  it "requires logged in" do
    response = ApiClient.exec(Users::New)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
