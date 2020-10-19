require "../../spec_helper"

describe Shield::DeletePasswordReset do
  it "deletes password reset" do
    email = "user@example.net"

    user = UserBox.create &.email(email)

    password_reset = StartPasswordReset.create!(
      params(email: email),
      remote_ip: Socket::IPAddress.new("1.2.3.4", 5)
    )

    DeletePasswordReset.submit(
      params(password_reset_id: password_reset.id)
    ) do |operation, deleted_password_reset|
      deleted_password_reset.should be_a(PasswordReset)

      PasswordResetQuery.new.id(password_reset.id).first?.should be_nil
    end
  end

  it "requires password reset id" do
    DeletePasswordReset.submit(
      params(some_id: 3)
    ) do |operation, deleted_password_reset|
      deleted_password_reset.should be_nil

      assert_invalid(operation.password_reset_id, " required")
    end
  end

  it "requires password reset exists" do
    DeletePasswordReset.submit(
      password_reset_id: 1_i64
    ) do |operation, deleted_password_reset|
      deleted_password_reset.should be_nil

      assert_invalid(operation.password_reset_id, "not exist")
    end
  end
end
