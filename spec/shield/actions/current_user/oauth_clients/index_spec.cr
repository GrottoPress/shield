require "../../../../spec_helper"

describe Shield::CurrentUser::OauthClients::Index do
  it "renders index page" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.browser_auth(email, password)

    response = client.exec(CurrentUser::OauthClients::Index)

    response.body.should eq("CurrentUser::OauthClients::IndexPage")
  end

  it "requires logged in" do
    response = ApiClient.exec(CurrentUser::OauthClients::Index)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
