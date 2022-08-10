require "../../../spec_helper"

describe Shield::OauthClients::Index do
  it "renders index page" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.browser_auth(email, password)

    response = client.exec(OauthClients::Index)

    response.body.should eq("OauthClients::IndexPage")
  end

  it "requires logged in" do
    response = ApiClient.exec(OauthClients::Index)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
