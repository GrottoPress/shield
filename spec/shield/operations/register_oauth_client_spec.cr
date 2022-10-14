require "../../spec_helper"

describe Shield::RegisterOauthClient do
  it "creates OAuth client" do
    name = "Awesome Client"
    redirect_uri = "https://example.com/oauth/callback"

    user = UserFactory.create

    RegisterOauthClient.create(
      params(name: name, public: false, redirect_uris: [redirect_uri]),
      user: user
    ) do |operation, oauth_client|
      oauth_client.should be_a(OauthClient)

      oauth_client.try do |_oauth_client|
        _oauth_client.name.should eq(name)
        _oauth_client.redirect_uris.should eq([redirect_uri])
        _oauth_client.status.active?.should be_true
      end

      operation.secret.should_not be_empty
    end
  end
end
