require "../../spec_helper"

describe Shield::DeletePasswordReset do
  it "deletes password reset" do
    email = "user@example.net"

    user = UserFactory.create &.email(email)
    UserOptionsFactory.create &.user_id(user.id)
    password_reset = PasswordResetFactory.create &.user_id(user.id)

    DeletePasswordReset.destroy(
      password_reset
    ) do |operation, deleted_password_reset|
      operation.deleted?.should be_true

      PasswordResetQuery.new.id(password_reset.id).first?.should be_nil
    end
  end
end
