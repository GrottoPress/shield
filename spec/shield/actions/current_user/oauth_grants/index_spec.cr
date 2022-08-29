require "../../../../spec_helper"

describe Shield::CurrentUser::OauthGrants::Index do
  it "renders index page" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.browser_auth(email, password)

    response = client.exec(CurrentUser::OauthGrants::Index)

    response.body.should eq("CurrentUser::OauthGrants::IndexPage")
  end

  it "requires logged in" do
    response = ApiClient.exec(CurrentUser::OauthGrants::Index)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
