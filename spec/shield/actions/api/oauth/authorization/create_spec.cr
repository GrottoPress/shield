require "../../../../../spec_helper"

describe Shield::Api::Oauth::Authorization::Create do
  it "grants authorization" do
    password = "password4APASSWORD<"

    resource_owner = UserFactory.create &.email("resource@owner.com")
      .password(password)

    UserOptionsFactory.create &.user_id(resource_owner.id)

    developer = UserFactory.create
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    client = ApiClient.new
    client.api_auth(resource_owner, password)

    response = client.exec(
      Api::Oauth::Authorization::Create,
      oauth_grant: {
        granted: true,
        code_challenge: "a1b2c3",
        code_challenge_method: "plain",
        scopes: [BearerScope.new(Api::Posts::Index).to_s],
        oauth_client_id: oauth_client.id,
        user_id: resource_owner.id,
      }
    )

    response.should send_json(200)
  end

  it "requires logged in" do
    response = ApiClient.exec(
      Api::Oauth::Authorization::Create,
      oauth_grant: {
        granted: true,
        code_challenge: "a1b2c3",
        code_challenge_method: "plain",
        scopes: [BearerScope.new(Api::Posts::Index).to_s],
        oauth_client_id: 5,
        user_id: 4,
      }
    )

    response.should send_json(401, logged_in: false)
  end
end
