require "../../spec_helper"

describe Shield::DeleteEmailConfirmation do
  it "deletes email confirmation" do
    email = "user@example.net"

    email_confirmation = StartEmailConfirmation.create!(
      params(email: email),
      remote_ip: Socket::IPAddress.new("1.2.3.4", 5)
    )

    DeleteEmailConfirmation.submit(
      params(email_confirmation_id: email_confirmation.id)
    ) do |operation, deleted_email_confirmation|
      deleted_email_confirmation.should be_a(EmailConfirmation)

      EmailConfirmationQuery.new.id(email_confirmation.id).first?.should be_nil
    end
  end

  it "requires email confirmation id" do
    DeleteEmailConfirmation.submit(
      params(some_id: 3)
    ) do |operation, deleted_email_confirmation|
      deleted_email_confirmation.should be_nil

      assert_invalid(operation.email_confirmation_id, " required")
    end
  end

  it "requires email confirmation exists" do
    DeleteEmailConfirmation.submit(
      email_confirmation_id: 1_i64
    ) do |operation, deleted_email_confirmation|
      deleted_email_confirmation.should be_nil

      assert_invalid(operation.email_confirmation_id, "not exist")
    end
  end
end
