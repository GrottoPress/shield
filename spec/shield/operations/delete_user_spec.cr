require "../../spec_helper"

describe Shield::DeleteUser do
  it "does not delete current user" do
    user = UserFactory.create

    DeleteUser.delete(user, current_user: user) do |operation, deleted_user|
      operation.deleted?.should be_false

      assert_invalid(operation.id, "current user")
      UserQuery.new.id(user.id).any?.should be_true
    end
  end
end
