require "../../spec_helper"

describe Shield::CreateBearerLogin do
  it "creates bearer login" do
    user = UserFactory.create
    UserOptionsFactory.create &.user_id(user.id)

    CreateBearerLogin.create(
      params(name: "some token"),
      scopes: ["posts.index"],
      allowed_scopes: ["posts.update", "posts.index", "current_user.show"],
      user: user
    ) do |operation, bearer_login|
      bearer_login.should be_a(BearerLogin)

      bearer_login.try(&.active?).should be_true
      operation.token.should_not be_empty
    end
  end

  it "sends login notification" do
    user = UserFactory.create
    UserOptionsFactory.create &.user_id(user.id).bearer_login_notify(true)

    CreateBearerLogin.create(
      params(name: "some token"),
      scopes: ["posts.index"],
      allowed_scopes: ["posts.update", "posts.index", "current_user.show"],
      user: user
    ) do |operation, bearer_login|
      bearer_login.should be_a(BearerLogin)

      bearer_login = BearerLoginQuery.preload_user(bearer_login.not_nil!)

      BearerLoginNotificationEmail.new(operation, bearer_login)
        .should(be_delivered)
    end
  end

  it "does not send login notification" do
    user = UserFactory.create
    UserOptionsFactory.create &.user_id(user.id).bearer_login_notify(false)

    CreateBearerLogin.create(
      params(name: "some token"),
      scopes: ["posts.index"],
      allowed_scopes: ["posts.update", "posts.index", "current_user.show"],
      user: user
    ) do |operation, bearer_login|
      bearer_login.should be_a(BearerLogin)

      BearerLoginNotificationEmail.new(operation, bearer_login.not_nil!)
        .should_not(be_delivered)
    end
  end

  it "requires user id" do
    CreateBearerLogin.create(
      params(name: "some token"),
      scopes: ["posts.index"],
      allowed_scopes: ["posts.update", "posts.index", "current_user.show"],
      user: nil
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      assert_invalid(operation.user_id, " required")
    end
  end

  it "requires valid user id" do
    CreateBearerLogin.create(
      params(name: "some token"),
      user_id: 111,
      scopes: ["posts.index"],
      allowed_scopes: ["posts.update", "posts.index", "current_user.show"],
      user: nil
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      assert_invalid(operation.user_id, "not exist")
    end
  end

  it "requires name" do
    CreateBearerLogin.create(
      scopes: ["posts.index"],
      allowed_scopes: ["posts.update", "posts.index", "current_user.show"],
      user_id: UserFactory.create.id,
      user: nil
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      assert_invalid(operation.name, " required")
    end
  end

  it "rejects existing name by same user" do
    name = "some token"
    user = UserFactory.create

    BearerLoginFactory.create &.user_id(user.id).name(name)

    CreateBearerLogin.create(
      params(name: name),
      scopes: ["current_user.show"],
      allowed_scopes: ["current_user.show", "posts.index"],
      user_id: user.id,
      user: nil
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      assert_invalid(operation.name, "already used")
    end
  end

  it "accepts existing name by different user" do
    name = "some token"

    user = UserFactory.create &.email("user@example.tld")
    user_2 = UserFactory.create &.email("someone@example.net")

    UserOptionsFactory.create &.user_id(user.id)
    UserOptionsFactory.create &.user_id(user_2.id)

    BearerLoginFactory.create &.user_id(user.id).name(name)

    CreateBearerLogin.create(
      params(name: name),
      scopes: ["current_user.show"],
      allowed_scopes: ["current_user.show", "posts.index"],
      user: user_2
    ) do |operation, bearer_login|
      bearer_login.should be_a(BearerLogin)
    end
  end
end
