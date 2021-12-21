require "../../../spec_helper"

private class SaveUser < User::SaveOperation
  permit_columns :email, :level, :password_digest

  include Shield::LogOutEverywhere
end

describe Shield::LogOutEverywhere do
  it "logs out everywhere when password changes" do
    password = "password12U-password"
    new_password = "assword12U-passwor"

    user = UserFactory.create &.password_digest(password)

    login_1 = LoginFactory.create &.user_id(user.id)
    login_2 = LoginFactory.create &.user_id(user.id)

    login_1.status.active?.should be_true
    login_2.status.active?.should be_true

    SaveUser.update(
      user,
      params(password_digest: new_password),
      current_login: nil
    ) do |operation, _|
      operation.saved?.should be_true

      login_1.reload.status.active?.should be_false
      login_2.reload.status.active?.should be_false
    end
  end

  it "retains current login when password changes" do
    password = "password12U-password"
    new_password = "assword12U-passwor"

    user = UserFactory.create &.password_digest(password)

    login_1 = LoginFactory.create &.user_id(user.id)
    login_2 = LoginFactory.create &.user_id(user.id)
    current_login = LoginFactory.create &.user_id(user.id)

    login_1.status.active?.should be_true
    login_2.status.active?.should be_true
    current_login.status.active?.should be_true

    SaveUser.update(
      user,
      params(password_digest: new_password),
      current_login: current_login
    ) do |operation, _|
      login_1.reload.status.active?.should be_false
      login_2.reload.status.active?.should be_false
      current_login.reload.status.active?.should be_true
    end
  end

  it "does not log other users out when password changes" do
    mary_email = "mary@example.tld"
    mary_password = "password12U-password"
    mary_new_password = "assword12U-passwor"

    john_email = "john@example.tld"
    john_password = "pasword12U-pasword"

    mary = UserFactory.create &.email(mary_email).password_digest(mary_password)
    mary_login = LoginFactory.create &.user_id(mary.id)

    john = UserFactory.create &.email(john_email).password_digest(john_password)
    john_login = LoginFactory.create &.user_id(john.id)

    mary_login.status.active?.should be_true
    john_login.status.active?.should be_true

    SaveUser.update(
      mary,
      params(password_digest: mary_new_password),
      current_login: nil
    ) do |operation, _|
      operation.saved?.should be_true

      mary_login.reload.status.active?.should be_false
      john_login.reload.status.active?.should be_true
    end
  end
end
