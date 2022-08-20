require "../../../spec_helper"

private class SaveBearerLogin < BearerLogin::SaveOperation
  permit_columns :oauth_client_id, :user_id, :active_at, :name, :token_digest

  include Shield::NotifyOauthAccessTokenIfSet
end

describe Shield::NotifyOauthAccessTokenIfSet do
  it "sends notification" do
    resource_owner = UserFactory.create &.settings(UserSettings.from_json({
      bearer_login_notify: true,
      login_notify: false,
      password_notify: false,
    }.to_json))

    developer = UserFactory.create &.email("dev@app.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    SaveBearerLogin.create(
      params(
        oauth_client_id: oauth_client.id,
        user_id: resource_owner.id,
        active_at: Time.utc,
        name: "New OAuth access token",
        token_digest: "a1b2c3"
      ),
      scopes: [BearerScope.new(Api::Posts::Index).to_s]
    ) do |operation, bearer_login|
      bearer_login.should be_a(BearerLogin)

      bearer_login = BearerLoginQuery.preload_user(bearer_login.not_nil!)

      OauthAccessTokenNotificationEmail.new(operation, bearer_login)
        .should(be_delivered)
    end
  end

  it "does not send notification" do
    resource_owner = UserFactory.create &.settings(UserSettings.from_json({
      bearer_login_notify: false,
      login_notify: false,
      password_notify: false,
    }.to_json))

    developer = UserFactory.create &.email("dev@app.com")
    oauth_client = OauthClientFactory.create &.user_id(developer.id)

    SaveBearerLogin.create(
      params(
        oauth_client_id: oauth_client.id,
        user_id: resource_owner.id,
        active_at: Time.utc,
        name: "New OAuth access token",
        token_digest: "a1b2c3"
      ),
      scopes: [BearerScope.new(Api::Posts::Index).to_s]
    ) do |operation, bearer_login|
      bearer_login.should be_a(BearerLogin)

      OauthAccessTokenNotificationEmail.new(operation, bearer_login.not_nil!)
        .should_not(be_delivered)
    end
  end
end
