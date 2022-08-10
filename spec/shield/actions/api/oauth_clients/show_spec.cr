require "../../../../spec_helper"

describe Shield::Api::OauthClients::Show do
  it "shows OAuth client" do
    password = "password4APASSWORD<"

    user = UserFactory.create &.password(password)
    oauth_client = OauthClientFactory.create &.user_id(user.id)
    UserOptionsFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.api_auth(user, password)

    response = client.exec(Api::OauthClients::Show.with(
      oauth_client_id: oauth_client.id
    ))

    response.should send_json(200, {status: "success"})
  end

  it "requires logged in" do
    response = ApiClient.exec(Api::OauthClients::Show.with(oauth_client_id: 5))

    response.should send_json(401, logged_in: false)
  end
end
