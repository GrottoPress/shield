require "../../../../spec_helper"

describe Shield::CurrentUser::OauthAccessTokens::Index do
  it "lists OAuth access tokens" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.browser_auth(email, password)

    response = client.exec(CurrentUser::OauthAccessTokens::Index)

    response.body.should eq("CurrentUser::BearerLogins::IndexPage")
  end

  it "requires logged in" do
    response = ApiClient.exec(CurrentUser::OauthAccessTokens::Index)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
