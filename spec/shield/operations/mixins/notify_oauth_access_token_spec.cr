require "../../../spec_helper"

private class SaveBearerLogin < BearerLogin::SaveOperation
  permit_columns :oauth_client_id,
    :user_id,
    :active_at,
    :name,
    :scopes,
    :token_digest

  include Shield::NotifyOauthAccessToken
end

describe Shield::NotifyOauthAccessToken do
  it "sends notification" do
    resource_owner = UserFactory.create

    UserOptionsFactory.create &.user_id(resource_owner.id)
      .oauth_access_token_notify(true)

    developer = UserFactory.create &.email("dev@app.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    SaveBearerLogin.create(params(
      oauth_client_id: oauth_client.id,
      user_id: resource_owner.id,
      active_at: Time.utc,
      name: "some token",
      token_digest: "abc",
      scopes: ["posts.index"]
    )) do |operation, bearer_login|
      bearer_login.should be_a(BearerLogin)

      bearer_login = BearerLoginQuery.preload_user(bearer_login.not_nil!)

      OauthAccessTokenNotificationEmail.new(operation, bearer_login)
        .should(be_delivered)
    end
  end

  it "does not send notification" do
    resource_owner = UserFactory.create

    UserOptionsFactory.create &.user_id(resource_owner.id)
      .oauth_access_token_notify(false)

    developer = UserFactory.create &.email("dev@app.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    SaveBearerLogin.create(params(
      oauth_client_id: oauth_client.id,
      user_id: resource_owner.id,
      active_at: Time.utc,
      name: "some token",
      token_digest: "abc",
      scopes: ["posts.index"]
    )) do |operation, bearer_login|
      bearer_login.should be_a(BearerLogin)

      OauthAccessTokenNotificationEmail.new(operation, bearer_login.not_nil!)
        .should_not(be_delivered)
    end
  end
end
