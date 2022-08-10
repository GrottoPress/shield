require "../../../../spec_helper"

describe Shield::CurrentUser::OauthClients::Create do
  it "creates OAuth client" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.browser_auth(email, password)

    response = client.exec(CurrentUser::OauthClients::Create, oauth_client: {
      name: "Some Client",
      redirect_uri: "https://example.co/cb",
      public: false
    })

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-OAuth-Client-ID"]?.should_not be_nil
  end

  it "requires logged in" do
    response = ApiClient.exec(CurrentUser::OauthClients::Create, oauth_client: {
      name: "Some Client",
      redirect_uri: "https://example.co/cb",
      public: false
    })

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
