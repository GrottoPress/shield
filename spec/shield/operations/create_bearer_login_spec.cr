require "../../spec_helper"

describe Shield::CreateBearerLogin do
  it "creates bearer login" do
    CreateBearerLogin.create(
      params(name: "some token"),
      scopes: ["posts.index"],
      all_scopes: ["posts.update", "posts.index", "current_user.show"],
      user_id: UserBox.create.id
    ) do |operation, bearer_login|
      bearer_login.should be_a(BearerLogin)

      bearer_login.try(&.active?).should be_true
      operation.token.should_not be_empty
    end
  end

  it "requires user id" do
    CreateBearerLogin.create(
      params(name: "some token"),
      scopes: ["posts.index"],
      all_scopes: ["posts.update", "posts.index", "current_user.show"],
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
      all_scopes: ["posts.update", "posts.index", "current_user.show"],
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      assert_invalid(operation.user_id, "not exist")
    end
  end

  it "requires name" do
    CreateBearerLogin.create(
      scopes: ["posts.index"],
      all_scopes: ["posts.update", "posts.index", "current_user.show"],
      user_id: UserBox.create.id
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      assert_invalid(operation.name, " required")
    end
  end

  it "rejects existing name by same user" do
    name = "some token"
    user = UserBox.create

    CreateBearerLogin.create!(
      params(name: name),
      scopes: ["posts.index"],
      all_scopes: ["posts.update", "posts.index"],
      user_id: user.id
    )

    CreateBearerLogin.create(
      params(name: name),
      scopes: ["current_user.show"],
      all_scopes: ["current_user.show", "posts.index"],
      user_id: user.id
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      assert_invalid(operation.name, "already used")
    end
  end

  it "accepts existing name by different user" do
    name = "some token"
    user = UserBox.create &.email("user@example.tld")
    user_2 = UserBox.create &.email("someone@example.net")

    CreateBearerLogin.create!(
      params(name: name),
      scopes: ["posts.index"],
      all_scopes: ["posts.update", "posts.index"],
      user_id: user.id
    )

    CreateBearerLogin.create(
      params(name: name),
      scopes: ["current_user.show"],
      all_scopes: ["current_user.show", "posts.index"],
      user_id: user_2.id
    ) do |operation, bearer_login|
      bearer_login.should be_a(BearerLogin)
    end
  end
end
