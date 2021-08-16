require "../../../spec_helper"

describe Shield::NotifyLoginIfSet do
  it "sends login notification" do
    email = "user@example.tld"
    password = "pass)word1Apassword"

    user = UserFactory.create &.email(email).password(password)

    UpdateUserWithSettings.update(
      user,
      login_notify: true,
      current_login: nil
    ) do |operation, updated_user|
      operation.saved?.should be_true
      updated_user.settings.login_notify.should be_true
    end

    LogUserInWithSettings.create(
      params(email: email, password: password),
      session: Lucky::Session.new,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    ) do |operation, login|
      operation.saved?.should be_true

      LoginNotificationEmail.new(operation, login.not_nil!).should(be_delivered)
    end
  end

  it "does not send login notification" do
    email = "user@example.tld"
    password = "pass)word1Apassword"

    user = UserFactory.create &.email(email).password(password)

    UpdateUserWithSettings.update(
      user,
      login_notify: false,
      current_login: nil
    ) do |operation, updated_user|
      operation.saved?.should be_true
      updated_user.settings.login_notify.should be_false
    end

    LogUserInWithSettings.create(
      params(email: email, password: password),
      session: Lucky::Session.new,
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    ) do |operation, login|
      operation.saved?.should be_true

      LoginNotificationEmail.new(operation, login.not_nil!)
        .should_not(be_delivered)
    end
  end
end
