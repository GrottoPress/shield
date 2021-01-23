require "../../spec_helper"

describe Shield::DeletePasswordReset do
  it "deletes password reset" do
    email = "user@example.net"

    user = UserBox.create &.email(email)
    UserOptionsBox.create &.user_id(user.id)
    password_reset = PasswordResetBox.create &.user_id(user.id)

    DeletePasswordReset.run(
      record: password_reset
    ) do |operation, deleted_password_reset|
      operation.deleted?.should be_true

      PasswordResetQuery.new.id(password_reset.id).first?.should be_nil
    end
  end
end
