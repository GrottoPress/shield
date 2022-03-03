require "../../spec_helper"

describe Shield::EndUserEmailConfirmations do
  it "ends active email confirmations" do
    user = UserFactory.create
    email_confirmation_1 = EmailConfirmationFactory.create &.user_id(user.id)
    email_confirmation_2 = EmailConfirmationFactory.create &.user_id(user.id)

    email_confirmation_1.status.active?.should be_true
    email_confirmation_2.status.active?.should be_true

    EndCurrentUserEmailConfirmations.update(user) do |operation, _|
      operation.saved?.should be_true

      email_confirmation_1.reload.status.active?.should be_false
      email_confirmation_2.reload.status.active?.should be_false
    end
  end

  it "does not end email confirmations of other users" do
    mary_email = "mary@example.tld"
    john_email = "john@example.tld"

    mary = UserFactory.create &.email(mary_email)
    mary_email_confirmation = EmailConfirmationFactory.create &.user_id(mary.id)

    john = UserFactory.create &.email(john_email)
    john_email_confirmation = EmailConfirmationFactory.create &.user_id(john.id)

    mary_email_confirmation.status.active?.should be_true
    john_email_confirmation.status.active?.should be_true

    EndCurrentUserEmailConfirmations.update(mary) do |operation, _|
      operation.saved?.should be_true

      mary_email_confirmation.reload.status.active?.should be_false
      john_email_confirmation.reload.status.active?.should be_true
    end
  end
end
