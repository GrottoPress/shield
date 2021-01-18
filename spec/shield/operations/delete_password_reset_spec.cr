require "../../spec_helper"

describe Shield::DeletePasswordReset do
  it "deletes password reset" do
    email = "user@example.net"

    user = UserBox.create &.email(email)
    UserOptionsBox.create &.user_id(user.id)

    password_reset = StartPasswordReset.create!(
      params(email: email),
      remote_ip: Socket::IPAddress.new("1.2.3.4", 5)
    )

    DeletePasswordReset.run(
      params(id: password_reset.id)
    ) do |operation, deleted_password_reset|
      deleted_password_reset.should be_a(PasswordReset)

      PasswordResetQuery.new.id(password_reset.id).first?.should be_nil
    end
  end

  it "requires password reset id" do
    DeletePasswordReset.run(
      params(some_id: 3)
    ) do |operation, deleted_password_reset|
      deleted_password_reset.should be_nil

      assert_invalid(operation.id, " required")
    end
  end

  it "requires password reset exists" do
    DeletePasswordReset.run(
      id: 1_i64
    ) do |operation, deleted_password_reset|
      deleted_password_reset.should be_nil

      assert_invalid(operation.id, "not exist")
    end
  end
end
