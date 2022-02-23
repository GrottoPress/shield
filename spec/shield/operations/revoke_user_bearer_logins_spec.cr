require "../../spec_helper"

describe Shield::RevokeUserBearerLogins do
  it "revokes bearer logins" do
    user = UserFactory.create
    bearer_login_1 = BearerLoginFactory.create &.user_id(user.id)
    bearer_login_2 = BearerLoginFactory.create &.user_id(user.id)

    bearer_login_1.status.active?.should be_true
    bearer_login_2.status.active?.should be_true

    RevokeCurrentUserBearerLogins.update(
      user,
      current_bearer_login: nil
    ) do |operation, _|
      operation.saved?.should be_true

      bearer_login_1.reload.status.active?.should be_false
      bearer_login_2.reload.status.active?.should be_false
    end
  end

  it "retains current bearer login" do
    user = UserFactory.create
    bearer_login_1 = BearerLoginFactory.create &.user_id(user.id)
    bearer_login_2 = BearerLoginFactory.create &.user_id(user.id)

    bearer_login_1.status.active?.should be_true
    bearer_login_2.status.active?.should be_true

    RevokeCurrentUserBearerLogins.update(
      user,
      current_bearer_login: bearer_login_1
    ) do |operation, _|
      operation.saved?.should be_true

      bearer_login_1.reload.status.active?.should be_true
      bearer_login_2.reload.status.active?.should be_false
    end
  end

  it "does not log other users out" do
    mary_email = "mary@example.tld"
    john_email = "john@example.tld"

    mary = UserFactory.create &.email(mary_email)
    mary_bearer_login = BearerLoginFactory.create &.user_id(mary.id)

    john = UserFactory.create &.email(john_email)
    john_bearer_login = BearerLoginFactory.create &.user_id(john.id)

    mary_bearer_login.status.active?.should be_true
    john_bearer_login.status.active?.should be_true

    RevokeCurrentUserBearerLogins.update(
      mary,
      current_bearer_login: nil
    ) do |operation, _|
      operation.saved?.should be_true

      mary_bearer_login.reload.status.active?.should be_false
      john_bearer_login.reload.status.active?.should be_true
    end
  end
end
