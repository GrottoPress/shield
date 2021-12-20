require "../../../spec_helper"

private class SaveBearerLogin < BearerLogin::SaveOperation
  permit_columns :user_id, :active_at, :name, :token_digest

  include Shield::ValidateBearerLogin
end

describe Shield::ValidateBearerLogin do
  it "requires scopes" do
    user = UserFactory.create

    SaveBearerLogin.create(
      params(
        name: "some token",
        user_id: user.id,
        active_at: Time.utc,
        token_digest: "abc"
      ),
      allowed_scopes: ["posts.update", "posts.index"]
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      assert_invalid(operation.scopes, "operation.error.bearer_scopes_required")
    end
  end

  it "requires user id" do
    SaveBearerLogin.create(
      params(
        name: "some token",
        active_at: Time.utc,
        token_digest: "abc"
      ),
      scopes: ["posts.index"],
      allowed_scopes: ["posts.update", "posts.index", "current_user.show"],
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      assert_invalid(operation.user_id, "operation.error.user_id_required")
    end
  end

  it "requires valid user id" do
    SaveBearerLogin.create(
      params(
        name: "some token",
        user_id: 123,
        active_at: Time.utc,
        token_digest: "abc"
      ),
      scopes: ["posts.index"],
      allowed_scopes: ["posts.update", "posts.index", "current_user.show"],
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      assert_invalid(operation.user_id, "operation.error.user_not_found")
    end
  end

  it "requires name" do
    user = UserFactory.create

    SaveBearerLogin.create(
      params(
        user_id: user.id,
        active_at: Time.utc,
        token_digest: "abc"
      ),
      scopes: ["posts.index"],
      allowed_scopes: ["posts.update", "posts.index", "current_user.show"],
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      assert_invalid(operation.name, "operation.error.name_required")
    end
  end

  it "rejects existing name by same user" do
    name = "some token"

    user = UserFactory.create
    BearerLoginFactory.create &.user_id(user.id).name(name)

    SaveBearerLogin.create(
      params(
        name: name,
        user_id: user.id,
        active_at: Time.utc,
        token_digest: "abc"
      ),
      scopes: ["current_user.show"],
      allowed_scopes: ["current_user.show", "posts.index"],
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      assert_invalid(operation.name, "operation.error.name_exists")
    end
  end

  it "accepts existing name by different user" do
    name = "some token"

    user = UserFactory.create &.email("user@example.tld")
    user_2 = UserFactory.create &.email("someone@example.net")

    UserOptionsFactory.create &.user_id(user.id)
    UserOptionsFactory.create &.user_id(user_2.id)

    BearerLoginFactory.create &.user_id(user_2.id).name(name)

    SaveBearerLogin.create(
      params(
        name: name,
        user_id: user.id,
        active_at: Time.utc,
        token_digest: "abc"
      ),
      scopes: ["current_user.show"],
      allowed_scopes: ["current_user.show", "posts.index"],
    ) do |operation, bearer_login|
      bearer_login.should be_a(BearerLogin)
    end
  end

  it "requires scopes not empty" do
    user = UserFactory.create

    SaveBearerLogin.create(
      params(
        name: "some token",
        user_id: user.id,
        active_at: Time.utc,
        token_digest: "abc"
      ),
      scopes: Array(String).new,
      allowed_scopes: ["posts.update", "posts.index"]
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      assert_invalid(operation.scopes, "operation.error.bearer_scopes_empty")
    end
  end

  it "requires valid scopes" do
    user = UserFactory.create

    SaveBearerLogin.create(
      params(
        name: "some token",
        user_id: user.id,
        active_at: Time.utc,
        token_digest: "abc"
      ),
      scopes: ["current_user.show"],
      allowed_scopes: ["posts.update", "posts.index"]
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      assert_invalid(operation.scopes, "operation.error.bearer_scopes_invalid")
    end
  end

  it "requires token digest" do
    user = UserFactory.create

    SaveBearerLogin.create(
      params(
        name: "some token",
        user_id: user.id,
        active_at: Time.utc
      ),
      scopes: ["posts.index"],
      allowed_scopes: ["posts.update", "posts.index"]
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      assert_invalid(operation.token_digest, "operation.error.token_required")
    end
  end
end
