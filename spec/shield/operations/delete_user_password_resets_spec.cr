require "../../spec_helper"

describe Shield::DeleteUserPasswordResets do
  it "deletes active password resets" do
    user = UserFactory.create
    password_reset_1 = PasswordResetFactory.create &.user_id(user.id)
    password_reset_2 = PasswordResetFactory.create &.user_id(user.id)

    password_reset_1.status.active?.should be_true
    password_reset_2.status.active?.should be_true

    DeleteCurrentUserPasswordResets.update(user) do |operation, _|
      operation.saved?.should be_true

      PasswordResetQuery.new.id(password_reset_1.id).first?.should be_nil
      PasswordResetQuery.new.id(password_reset_2.id).first?.should be_nil
    end
  end

  it "does not delete password resets of other users" do
    mary_email = "mary@example.tld"
    john_email = "john@example.tld"

    mary = UserFactory.create &.email(mary_email)
    mary_password_reset = PasswordResetFactory.create &.user_id(mary.id)

    john = UserFactory.create &.email(john_email)
    john_password_reset = PasswordResetFactory.create &.user_id(john.id)

    mary_password_reset.status.active?.should be_true
    john_password_reset.status.active?.should be_true

    DeleteCurrentUserPasswordResets.update(mary) do |operation, _|
      operation.saved?.should be_true

      PasswordResetQuery.new.id(mary_password_reset.id).first?.should be_nil

      PasswordResetQuery.new
        .id(john_password_reset.id)
        .first?
        .should(be_a PasswordReset)
    end
  end
end
