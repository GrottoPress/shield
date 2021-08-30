require "../../../spec_helper"

private class SaveBearerLogin < BearerLogin::SaveOperation
  permit_columns :user_id, :active_at, :name, :token_digest

  include Shield::ValidateScopes
end

describe Shield::ValidateScopes do
  it "requires scopes" do
    user = UserFactory.create

    SaveBearerLogin.create(
      params(
        name: "some token",
        user_id: user.id,
        token_digest: "abc",
        active_at: Time.utc
      ),
      allowed_scopes: ["posts.update", "posts.index"]
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      assert_invalid(operation.scopes, " required")
    end
  end

  it "requires scopes not empty" do
    user = UserFactory.create

    SaveBearerLogin.create(
      params(
        name: "some token",
        user_id: user.id,
        token_digest: "abc",
        active_at: Time.utc
      ),
      scopes: Array(String).new,
      allowed_scopes: ["posts.update", "posts.index"]
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      assert_invalid(operation.scopes, " required")
    end
  end

  it "requires valid scopes" do
    user = UserFactory.create

    SaveBearerLogin.create(
      params(
        name: "some token",
        user_id: user.id,
        token_digest: "abc",
        active_at: Time.utc
      ),
      scopes: ["current_user.show"],
      allowed_scopes: ["posts.update", "posts.index"]
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      assert_invalid(operation.scopes, " invalid")
    end
  end
end
