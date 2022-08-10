require "../../spec_helper"

describe Shield::CreateOauthClient do
  it "creates OAuth client" do
    name = "Awesome Client"
    redirect_uri = "https://example.com/oauth/callback"

    user = UserFactory.create

    CreateOauthClient.create(
      params(name: name, redirect_uri: redirect_uri, public: false),
      user: user
    ) do |operation, oauth_client|
      oauth_client.should be_a(OauthClient)

      oauth_client.try do |_oauth_client|
        _oauth_client.name.should eq(name)
        _oauth_client.redirect_uri.should eq(redirect_uri)
        _oauth_client.status.active?.should be_true
      end

      operation.secret.should_not be_empty
    end
  end
end
