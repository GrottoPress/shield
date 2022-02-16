require "../../spec_helper"

describe Shield::DeleteUser do
  it "does not delete current user" do
    user = UserFactory.create

    DeleteUser.delete(user, current_user: user) do |operation, _|
      operation.deleted?.should be_false
      operation.id.should have_error("operation.error.self_delete_forbidden")

      # ameba:disable Performance/AnyInsteadOfEmpty
      UserQuery.new.id(user.id).any?.should be_true
    end
  end
end
