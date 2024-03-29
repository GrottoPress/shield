require "../../../spec_helper"

private class SaveEmailConfirmation < EmailConfirmation::SaveOperation
  permit_columns :user_id, :active_at, :email, :ip_address, :token_digest

  include Shield::ValidateEmailConfirmation
end

describe Shield::ValidateEmailConfirmation do
  it "requires email" do
    user = UserFactory.create

    SaveEmailConfirmation.create(params(
      user_id: user.id,
      active_at: Time.utc,
      ip_address: "1.2.3.4",
      token_digest: "abc"
    )) do |operation, email_confirmation|
      email_confirmation.should be_nil

      operation.email.should have_error("operation.error.email_required")
    end
  end

  it "rejects invalid email" do
    user = UserFactory.create

    SaveEmailConfirmation.create(params(
      user_id: user.id,
      email: "user",
      active_at: Time.utc,
      ip_address: "1.2.3.4",
      token_digest: "abc"
    )) do |operation, email_confirmation|
      email_confirmation.should be_nil

      operation.email.should have_error("operation.error.email_invalid")
    end
  end

  it "rejects existing email" do
    email = "user@example.tld"

    user = UserFactory.create
    UserFactory.create &.email(email)

    SaveEmailConfirmation.create(params(
      user_id: user.id,
      email: email,
      active_at: Time.utc,
      token_digest: "abc"
    )) do |operation, email_confirmation|
      email_confirmation.should be_nil

      operation.user_email?.should be_true
      operation.email.should have_error("operation.error.email_exists")
    end
  end

  it "requires IP address" do
    user = UserFactory.create

    SaveEmailConfirmation.create(params(
      user_id: user.id,
      email: "user@example.tld",
      active_at: Time.utc,
      token_digest: "abc"
    )) do |operation, email_confirmation|
      email_confirmation.should be_nil

      operation.ip_address
        .should have_error("operation.error.ip_address_required")
    end
  end
end
