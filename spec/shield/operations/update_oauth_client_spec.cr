require "../../spec_helper"

describe Shield::UpdateOauthClient do
  it "updates OAuth client" do
    new_name = "Another Client"

    user = UserFactory.create

    oauth_client = OauthClientFactory.create &.user_id(user.id)
      .name("New Client")

    UpdateOauthClient.update(
      oauth_client,
      params(name: new_name)
    ) do |operation, updated_oauth_client|
      operation.saved?.should be_true

      updated_oauth_client.name.should eq(new_name)
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
