require "../../../spec_helper"

describe Shield::ValidateScopes do
  it "requires scopes" do
    CreateBearerLogin.create(
      params(name: "some token"),
      allowed_scopes: ["posts.update", "posts.index"],
      user_id: UserBox.create.id
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      assert_invalid(operation.scopes, " required")
    end
  end

  it "requires scopes not empty" do
    CreateBearerLogin.create(
      params(name: "some token"),
      scopes: Array(String).new,
      allowed_scopes: ["posts.update", "posts.index"],
      user_id: UserBox.create.id
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      assert_invalid(operation.scopes, " required")
    end
  end

  it "requires valid scopes" do
    CreateBearerLogin.create(
      params(name: "some token"),
      scopes: ["current_user.show"],
      allowed_scopes: ["posts.update", "posts.index"],
      user_id: UserBox.create.id
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      assert_invalid(operation.scopes, " invalid")
    end
  end
end
