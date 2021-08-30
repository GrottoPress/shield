require "../../../spec_helper"

private class SaveLogin < Login::SaveOperation
  permit_columns :user_id, :active_at, :token_digest, :ip_address

  include Shield::NotifyLogin
end

describe Shield::NotifyLogin do
  it "sends login notification" do
    email = "user@example.tld"
    password = "pass)word1Apassword"

    user = UserFactory.create &.email(email).password(password)
    UserOptionsFactory.create &.user_id(user.id).login_notify(true)

    SaveLogin.create(params(
      user_id: user.id,
      active_at: Time.utc,
      token_digest: "abc",
      ip_address: "1.2.3.4"
    )) do |operation, login|
      login.should be_a(Login)

      login = LoginQuery.preload_user(login.not_nil!)
      LoginNotificationEmail.new(operation, login).should(be_delivered)
    end
  end

  it "does not send login notification if option is false" do
    password = "pass)word1Apassword"
    email = "user@example.tld"

    user = UserFactory.create &.email(email).password(password)
    UserOptionsFactory.create &.user_id(user.id).login_notify(false)

    SaveLogin.create(params(
      user_id: user.id,
      active_at: Time.utc,
      token_digest: "abc",
      ip_address: "1.2.3.4"
    )) do |operation, login|
      login.should be_a(Login)

      LoginNotificationEmail.new(operation, login.not_nil!)
        .should_not(be_delivered)
    end
  end
end
