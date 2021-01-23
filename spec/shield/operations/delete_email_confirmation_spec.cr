require "../../spec_helper"

describe Shield::DeleteEmailConfirmation do
  it "deletes email confirmation" do
    email = "user@example.net"

    email_confirmation = EmailConfirmationBox.create &.email(email)

    DeleteEmailConfirmation.run(
      record: email_confirmation
    ) do |operation, deleted_email_confirmation|
      operation.deleted?.should be_true

      EmailConfirmationQuery.new.id(email_confirmation.id).first?.should be_nil
    end
  end
end
