require "../../spec_helper"

describe Shield::DeleteEmailConfirmation do
  it "deletes email confirmation" do
    email = "user@example.net"

    email_confirmation = EmailConfirmationBox.create &.email(email)

    DeleteEmailConfirmation.run(
      params(id: email_confirmation.id)
    ) do |operation, deleted_email_confirmation|
      deleted_email_confirmation.should be_a(EmailConfirmation)

      EmailConfirmationQuery.new.id(email_confirmation.id).first?.should be_nil
    end
  end

  it "requires email confirmation id" do
    DeleteEmailConfirmation.run(
      params(some_id: 3)
    ) do |operation, deleted_email_confirmation|
      deleted_email_confirmation.should be_nil

      assert_invalid(operation.id, " required")
    end
  end

  it "requires email confirmation exists" do
    DeleteEmailConfirmation.run(
      id: 1_i64
    ) do |operation, deleted_email_confirmation|
      deleted_email_confirmation.should be_nil

      assert_invalid(operation.id, "not exist")
    end
  end
end
