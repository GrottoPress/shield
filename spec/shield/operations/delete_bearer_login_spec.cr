require "../../spec_helper"

describe Shield::DeleteBearerLogin do
  it "deletes bearer login" do
    bearer_login = CreateBearerLogin.create!(
      params(name: "super secret"),
      scopes: ["posts.index"],
      all_scopes: ["posts.update", "posts.index"],
      user_id: UserBox.create.id
    )

    DeleteBearerLogin.submit(
      params(bearer_login_id: bearer_login.id)
    ) do |operation, deleted_bearer_login|
      deleted_bearer_login.should be_a(BearerLogin)

      BearerLoginQuery.new.id(bearer_login.id).first?.should be_nil
    end
  end

  it "requires bearer login id" do
    DeleteBearerLogin.submit(
      params(some_id: 3)
    ) do |operation, deleted_bearer_login|
      deleted_bearer_login.should be_nil

      assert_invalid(operation.bearer_login_id, " required")
    end
  end

  it "requires bearer login exists" do
    DeleteBearerLogin.submit(
      bearer_login_id: 1_i64
    ) do |operation, deleted_bearer_login|
      deleted_bearer_login.should be_nil

      assert_invalid(operation.bearer_login_id, "not exist")
    end
  end
end
