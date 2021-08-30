require "../../../spec_helper"

private class SaveUser < User::SaveOperation
  permit_columns :email, :level, :password_digest

  include Shield::NotifyPasswordChange
end

describe Shield::NotifyPasswordChange do
  it "sends password change notification" do
    password = "pass)word1Apassword"
    new_password = "ass)word1Apasswor"

    user = UserFactory.create &.password_digest(password)
    UserOptionsFactory.create &.user_id(user.id).password_notify(true)

    SaveUser.update(
      user,
      params(password_digest: new_password),
    ) do |operation, updated_user|
      operation.saved?.should be_true

      PasswordChangeNotificationEmail.new(operation, updated_user)
        .should(be_delivered)
    end
  end

  it "does not send password change notification if option is false" do
    password = "pass)word1Apassword"
    new_password = "ass)word1Apassword"

    user = UserFactory.create &.password_digest(password)
    UserOptionsFactory.create &.user_id(user.id).password_notify(false)

    SaveUser.update(
      user,
      params(password_digest: new_password)
    ) do |operation, updated_user|
      operation.saved?.should be_true

      PasswordChangeNotificationEmail.new(operation, updated_user)
        .should_not(be_delivered)
    end
  end

  it "does not send password change notification if password did not change" do
    password = "pass)word1Apassword"

    user = UserFactory.create &.password_digest(password).email("aaa@bbb.ccc")
    UserOptionsFactory.create &.user_id(user.id).password_notify(true)

    SaveUser.update(
      user,
      params(email: "user@example.tld", password_digest: password)
    ) do |operation, updated_user|
      operation.saved?.should be_true

      PasswordChangeNotificationEmail.new(operation, updated_user)
        .should_not(be_delivered)
    end
  end
end
