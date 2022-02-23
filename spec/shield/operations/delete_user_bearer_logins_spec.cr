require "../../spec_helper"

describe Shield::DeleteUserBearerLogins do
  it "deletes bearer logins" do
    user = UserFactory.create
    bearer_login_1 = BearerLoginFactory.create &.user_id(user.id)
    bearer_login_2 = BearerLoginFactory.create &.user_id(user.id)

    bearer_login_1.status.active?.should be_true
    bearer_login_2.status.active?.should be_true

    DeleteCurrentUserBearerLogins.update(
      user,
      current_bearer_login: nil
    ) do |operation, _|
      operation.saved?.should be_true

      BearerLoginQuery.new.id(bearer_login_1.id).first?.should be_nil
      BearerLoginQuery.new.id(bearer_login_2.id).first?.should be_nil
    end
  end

  it "retains current bearer login" do
    user = UserFactory.create
    bearer_login_1 = BearerLoginFactory.create &.user_id(user.id)
    bearer_login_2 = BearerLoginFactory.create &.user_id(user.id)

    bearer_login_1.status.active?.should be_true
    bearer_login_2.status.active?.should be_true

    DeleteCurrentUserBearerLogins.update(
      user,
      current_bearer_login: bearer_login_1
    ) do |operation, _|
      operation.saved?.should be_true

      BearerLoginQuery.new.id(bearer_login_1.id).first?.should(be_a BearerLogin)
      BearerLoginQuery.new.id(bearer_login_2.id).first?.should be_nil
    end
  end

  it "does not delete bearer logins of other users" do
    mary_email = "mary@example.tld"
    john_email = "john@example.tld"

    mary = UserFactory.create &.email(mary_email)
    mary_bearer_login = BearerLoginFactory.create &.user_id(mary.id)

    john = UserFactory.create &.email(john_email)
    john_bearer_login = BearerLoginFactory.create &.user_id(john.id)

    mary_bearer_login.status.active?.should be_true
    john_bearer_login.status.active?.should be_true

    DeleteCurrentUserBearerLogins.update(
      mary,
      current_bearer_login: nil
    ) do |operation, _|
      operation.saved?.should be_true

      BearerLoginQuery.new.id(mary_bearer_login.id).first?.should be_nil

      BearerLoginQuery.new
        .id(john_bearer_login.id)
        .first?
        .should(be_a BearerLogin)
    end
  end
end
