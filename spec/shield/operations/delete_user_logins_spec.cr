require "../../spec_helper"

describe Shield::DeleteUserLogins do
  it "logs user out everywhere" do
    user = UserFactory.create
    login_1 = LoginFactory.create &.user_id(user.id)
    login_2 = LoginFactory.create &.user_id(user.id)

    login_1.status.active?.should be_true
    login_2.status.active?.should be_true

    DeleteLoginsEverywhere.update(
      user,
      current_login: nil
    ) do |operation, _|
      operation.saved?.should be_true

      LoginQuery.new.id(login_1.id).first?.should be_nil
      LoginQuery.new.id(login_2.id).first?.should be_nil
    end
  end

  it "retains current login" do
    user = UserFactory.create
    login_1 = LoginFactory.create &.user_id(user.id)
    login_2 = LoginFactory.create &.user_id(user.id)

    login_1.status.active?.should be_true
    login_2.status.active?.should be_true

    DeleteLoginsEverywhere.update(
      user,
      current_login: login_1
    ) do |operation, _|
      operation.saved?.should be_true

      LoginQuery.new.id(login_1.id).first?.should be_a(Login)
      LoginQuery.new.id(login_2.id).first?.should be_nil
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

    DeleteLoginsEverywhere.update(
      mary,
      current_login: nil
    ) do |operation, _|
      operation.saved?.should be_true

      LoginQuery.new.id(mary_login.id).first?.should be_nil
      LoginQuery.new.id(john_login.id).first?.should be_a(Login)
    end
  end
end
