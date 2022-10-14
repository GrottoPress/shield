require "../../../spec_helper"

private class SaveBearerLogin < BearerLogin::SaveOperation
  permit_columns :user_id, :active_at, :name, :scopes, :token_digest

  include Shield::NotifyBearerLogin
end

describe Shield::NotifyBearerLogin do
  it "sends login notification" do
    user = UserFactory.create
    UserOptionsFactory.create &.user_id(user.id).bearer_login_notify(true)

    SaveBearerLogin.create(params(
      name: "some token",
      user_id: user.id,
      token_digest: "abc",
      active_at: Time.utc,
      scopes: ["posts.index"]
    )) do |operation, bearer_login|
      bearer_login.should be_a(BearerLogin)

      bearer_login = BearerLoginQuery.preload_user(bearer_login.not_nil!)

      BearerLoginNotificationEmail.new(operation, bearer_login)
        .should(be_delivered)
    end
  end

  it "does not send login notification if option is false" do
    user = UserFactory.create
    UserOptionsFactory.create &.user_id(user.id).bearer_login_notify(false)

    SaveBearerLogin.create(params(
      name: "some token",
      user_id: user.id,
      token_digest: "abc",
      active_at: Time.utc,
      scopes: ["posts.index"]
    )) do |operation, bearer_login|
      bearer_login.should be_a(BearerLogin)

      BearerLoginNotificationEmail.new(operation, bearer_login.not_nil!)
        .should_not(be_delivered)
    end
  end
end
