require "../../../../spec_helper"

describe Shield::Oauth::Authorization::New do
  it "renders new page" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.browser_auth(email, password)

    response = client.exec(Oauth::Authorization::New)

    response.body.should eq("Oauth::Authorization::NewPage")
  end

  it "requires logged in" do
    response = ApiClient.exec(Oauth::Authorization::New)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
