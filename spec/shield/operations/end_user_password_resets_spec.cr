require "../../spec_helper"

describe Shield::EndUserPasswordResets do
  it "ends active password resets" do
    user = UserFactory.create
    password_reset_1 = PasswordResetFactory.create &.user_id(user.id)
    password_reset_2 = PasswordResetFactory.create &.user_id(user.id)

    password_reset_1.status.active?.should be_true
    password_reset_2.status.active?.should be_true

    EndCurrentUserPasswordResets.update(user) do |operation, _|
      operation.saved?.should be_true

      password_reset_1.reload.status.active?.should be_false
      password_reset_2.reload.status.active?.should be_false
    end
  end

  it "does not end password resets of other users" do
    mary_email = "mary@example.tld"
    john_email = "john@example.tld"

    mary = UserFactory.create &.email(mary_email)
    mary_password_reset = PasswordResetFactory.create &.user_id(mary.id)

    john = UserFactory.create &.email(john_email)
    john_password_reset = PasswordResetFactory.create &.user_id(john.id)

    mary_password_reset.status.active?.should be_true
    john_password_reset.status.active?.should be_true

    EndCurrentUserPasswordResets.update(mary) do |operation, _|
      operation.saved?.should be_true

      mary_password_reset.reload.status.active?.should be_false
      john_password_reset.reload.status.active?.should be_true
    end
  end
end
