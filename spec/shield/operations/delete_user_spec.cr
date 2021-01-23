require "../../spec_helper"

describe Shield::DeleteUser do
  it "deletes user" do
    user = UserBox.create
    user_2 = UserBox.create &.email("someone@somewhere.tld")

    DeleteUser.run(
      record: user,
      current_user: user_2
    ) do |operation, deleted_user|
      operation.deleted?.should be_true

      UserQuery.new.id(user.id).first?.should be_nil
    end
  end

  it "does not delete current user" do
    user = UserBox.create

    DeleteUser.run(
      record: user,
      current_user: user
    ) do |operation, deleted_user|
      operation.deleted?.should be_false

      assert_invalid(operation, :user, "current user")
      UserQuery.new.id(user.id).first?.should be_a(User)
    end
  end
end
