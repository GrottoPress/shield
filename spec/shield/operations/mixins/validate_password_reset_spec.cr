require "../../../spec_helper"

private class SavePasswordReset < PasswordReset::SaveOperation
  attribute email : String

  permit_columns :active_at, :ip_address, :token_digest

  include Shield::ValidatePasswordReset
end

describe Shield::ValidatePasswordReset do
  it "requires email" do
    SavePasswordReset.create(params(
      active_at: Time.utc,
      ip_address: "1.2.3.4",
      token_digest: "abc"
    )) do |operation, login|
      login.should be_nil

      operation.email.should have_error("operation.error.email_required")
    end
  end

  it "requires IP address" do
    SavePasswordReset.create(params(
      active_at: Time.utc,
      email: "user@example.tld",
      token_digest: "abc"
    )) do |operation, login|
      login.should be_nil

      operation.ip_address
        .should have_error("operation.error.ip_address_required")
    end
  end

  it "requires valid email format" do
    SavePasswordReset.create(params(
      active_at: Time.utc,
      email: "user",
      ip_address: "1.2.3.4",
      token_digest: "abc"
    )) do |operation, login|
      login.should be_nil

      operation.email.should have_error("operation.error.email_invalid")
    end
  end

  it "requires existing email" do
    UserFactory.create &.email("who@where.how")

    SavePasswordReset.create(params(
      active_at: Time.utc,
      email: "user@example.tld",
      ip_address: "1.2.3.4",
      token_digest: "abc"
    )) do |operation, login|
      login.should be_nil

      operation.email.should have_error("operation.error.email_not_found")
    end
  end
end
