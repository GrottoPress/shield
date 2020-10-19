require "../../spec_helper"

describe Shield::DeleteUser do
  it "deletes user" do
    user = UserBox.create

    DeleteUser.submit(
      params(user_id: user.id),
      current_user: nil
    ) do |operation, deleted_user|
      deleted_user.should be_a(User)

      UserQuery.new.id(user.id).first?.should be_nil
    end
  end

  it "does not delete current user" do
    user = UserBox.create

    DeleteUser.submit(
      params(user_id: user.id),
      current_user: user
    ) do |operation, deleted_user|
      deleted_user.should be_nil

      assert_invalid(operation.user_id, "current user")
    end
  end

  it "requires user id" do
    DeleteUser.submit(current_user: nil) do |operation, deleted_user|
      deleted_user.should be_nil

      assert_invalid(operation.user_id, " required")
    end
  end

  it "requires user exists" do
    DeleteUser.submit(
      user_id: 1_i64,
      current_user: nil
    ) do |operation, deleted_user|
      deleted_user.should be_nil

      assert_invalid(operation.user_id, "not exist")
    end
  end
end
