require "../../../../spec_helper"

describe Shield::Api::OauthAuthorizations::Show do
  it "renders show page" do
    password = "password4APASSWORD<"

    resource_owner = UserFactory.create &.email("resource@owner.com")
      .password(password)

    UserOptionsFactory.create &.user_id(resource_owner.id)

    developer = UserFactory.create
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    oauth_authorization =
      OauthAuthorizationFactory.create &.user_id(resource_owner.id)
        .oauth_client_id(oauth_client.id)

    client = ApiClient.new
    client.api_auth(resource_owner, password)

    response = client.exec(Api::OauthAuthorizations::Show.with(
      oauth_authorization_id: oauth_authorization.id
    ))

    response.should send_json(200, {status: "success"})
  end

  it "requires logged in" do
    response = ApiClient.exec(Api::OauthAuthorizations::Show.with(
      oauth_authorization_id: 45
    ))

    response.should send_json(401, logged_in: false)
  end
end
