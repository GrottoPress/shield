require "../../../../spec_helper"

describe Shield::CurrentUser::OauthClients::New do
  it "renders new page" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.browser_auth(email, password)

    response = client.exec(CurrentUser::OauthClients::New)

    response.body.should eq("CurrentUser::OauthClients::NewPage")
  end

  it "requires logged in" do
    response = ApiClient.exec(CurrentUser::OauthClients::New)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
