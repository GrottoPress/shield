require "../../spec_helper"

describe Shield::UpdateOauthClient do
  it "updates OAuth client" do
    new_name = "Another Client"
    new_redirect_uri = "https://my.app/cb"

    user = UserFactory.create

    oauth_client = OauthClientFactory.create &.user_id(user.id)
      .name("New Client")
      .redirect_uris(["myapp://cb"])

    UpdateOauthClient.update(
      oauth_client,
      params(name: new_name),
      redirect_uris: [new_redirect_uri]
    ) do |operation, updated_oauth_client|
      operation.saved?.should be_true

      updated_oauth_client.name.should eq(new_name)
      updated_oauth_client.redirect_uris.should eq([new_redirect_uri])
    end
  end

  it "ensures OAuth client is active" do
    user = UserFactory.create

    oauth_client = OauthClientFactory.create &.user_id(user.id)
      .inactive_at(Time.utc)

    UpdateOauthClient.update(
      oauth_client,
      params(name: "super duper secret")
    ) do |operation, _|
      operation.saved?.should be_false

      operation.name.should have_error("operation.error.oauth_client_inactive")
    end
  end
end
