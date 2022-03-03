require "../../spec_helper"

describe Shield::DeleteUserEmailConfirmations do
  it "deletes active email confirmations" do
    user = UserFactory.create
    email_confirmation = EmailConfirmationFactory.create &.user_id(user.id)
    email_confirmation_2 = EmailConfirmationFactory.create &.user_id(user.id)

    email_confirmation.status.active?.should be_true
    email_confirmation_2.status.active?.should be_true

    DeleteCurrentUserEmailConfirmations.update(user) do |operation, _|
      operation.saved?.should be_true

      EmailConfirmationQuery.new
        .id(email_confirmation.id)
        .first?
        .should(be_nil)

      EmailConfirmationQuery.new
        .id(email_confirmation_2.id)
        .first?
        .should(be_nil)
    end
  end

  it "does not delete email confirmations of other users" do
    mary_email = "mary@example.tld"
    john_email = "john@example.tld"

    mary = UserFactory.create &.email(mary_email)
    mary_email_confirmation = EmailConfirmationFactory.create &.user_id(mary.id)

    john = UserFactory.create &.email(john_email)
    john_email_confirmation = EmailConfirmationFactory.create &.user_id(john.id)

    mary_email_confirmation.status.active?.should be_true
    john_email_confirmation.status.active?.should be_true

    DeleteCurrentUserEmailConfirmations.update(mary) do |operation, _|
      operation.saved?.should be_true

      EmailConfirmationQuery.new
        .id(mary_email_confirmation.id)
        .first?
        .should(be_nil)

      EmailConfirmationQuery.new
        .id(john_email_confirmation.id)
        .first?
        .should(be_a EmailConfirmation)
    end
  end
end
