require "../../../../spec_helper"

describe Shield::Api::OauthClients::Destroy do
  it "deactivates OAuth client" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    user = UserFactory.create &.email(email).password(password)
    UserOptionsFactory.create &.user_id(user.id)
    oauth_client = OauthClientFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.api_auth(user, password)

    response = client.exec(Api::OauthClients::Destroy.with(
      oauth_client_id: oauth_client.id
    ))

    response.should send_json(200, {
      message: "action.oauth_client.destroy.success"
    })

    oauth_client.reload.status.inactive?.should be_true
  end

  it "requires logged in" do
    response = ApiClient.exec(Api::OauthClients::Destroy.with(
      oauth_client_id: 45
    ))

    response.should send_json(401, logged_in: false)
  end
end
