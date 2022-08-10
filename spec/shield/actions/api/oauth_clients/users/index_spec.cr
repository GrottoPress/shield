require "../../../../../spec_helper"

describe Shield::Api::OauthClients::Users::Index do
  it "renders index page" do
    password = "password4APASSWORD<"

    developer = UserFactory.create &.password(password)
    UserOptionsFactory.create &.user_id(developer.id)
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    client = ApiClient.new
    client.api_auth(developer, password)

    response = client.exec(Api::OauthClients::Users::Index.with(
      oauth_client_id: oauth_client.id
    ))

    response.should send_json(200, {status: "success"})
  end

  it "requires logged in" do
    developer = UserFactory.create
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    response = ApiClient.exec(Api::OauthClients::Users::Index.with(
      oauth_client_id: oauth_client.id
    ))

    response.should send_json(401, logged_in: false)
  end
end
