require "../../spec_helper"

describe Shield::DeleteBearerLogin do
  it "deletes bearer login" do
    bearer_login = BearerLoginBox.create &.user_id(UserBox.create.id)

    DeleteBearerLogin.run(
      params(id: bearer_login.id)
    ) do |operation, deleted_bearer_login|
      deleted_bearer_login.should be_a(BearerLogin)

      BearerLoginQuery.new.id(bearer_login.id).first?.should be_nil
    end
  end

  it "requires bearer login id" do
    DeleteBearerLogin.run(
      params(some_id: 3)
    ) do |operation, deleted_bearer_login|
      deleted_bearer_login.should be_nil

      assert_invalid(operation.id, " required")
    end
  end

  it "requires bearer login exists" do
    DeleteBearerLogin.run(id: 1_i64) do |operation, deleted_bearer_login|
      deleted_bearer_login.should be_nil

      assert_invalid(operation.id, "not exist")
    end
  end
end
