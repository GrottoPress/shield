require "../../spec_helper"

describe Shield::LogOutEverywhere do
  it "logs user out everywhere" do
    user = UserFactory.create
    login_1 = LoginFactory.create &.user_id(user.id)
    login_2 = LoginFactory.create &.user_id(user.id)

    login_1.status.active?.should be_true
    login_2.status.active?.should be_true

    LogOutEverywhere.update(
      user,
      current_login: nil
    ) do |operation, _|
      operation.saved?.should be_true

      login_1.reload.status.active?.should be_false
      login_2.reload.status.active?.should be_false
    end
  end

  it "retains current login" do
    user = UserFactory.create
    login_1 = LoginFactory.create &.user_id(user.id)
    login_2 = LoginFactory.create &.user_id(user.id)

    login_1.status.active?.should be_true
    login_2.status.active?.should be_true

    LogOutEverywhere.update(
      user,
      current_login: login_1
    ) do |operation, _|
      operation.saved?.should be_true

      login_1.reload.status.active?.should be_true
      login_2.reload.status.active?.should be_false
    end
  end

  it "does not log other users out" do
    mary_email = "mary@example.tld"
    john_email = "john@example.tld"

    mary = UserFactory.create &.email(mary_email)
    mary_login = LoginFactory.create &.user_id(mary.id)

    john = UserFactory.create &.email(john_email)
    john_login = LoginFactory.create &.user_id(john.id)

    mary_login.status.active?.should be_true
    john_login.status.active?.should be_true

    LogOutEverywhere.update(
      mary,
      current_login: nil
    ) do |operation, _|
      operation.saved?.should be_true

      mary_login.reload.status.active?.should be_false
      john_login.reload.status.active?.should be_true
    end
  end
end
