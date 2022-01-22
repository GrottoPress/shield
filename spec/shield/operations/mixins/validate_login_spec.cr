require "../../../spec_helper"

private class SaveLogin < Login::SaveOperation
  attribute email : String
  attribute password : String

  permit_columns :active_at, :ip_address, :token_digest

  include Shield::ValidateLogin
end

describe Shield::ValidateLogin do
  it "requires email" do
    SaveLogin.create(params(
      active_at: Time.utc,
      ip_address: "1.2.3.4",
      password: "secret",
      token_digest: "abc"
    )) do |operation, login|
      login.should be_nil

      operation.email.should have_error("operation.error.email_required")
    end
  end

  it "requires password" do
    SaveLogin.create(params(
      active_at: Time.utc,
      email: "user@example.tld",
      ip_address: "1.2.3.4",
      token_digest: "abc"
    )) do |operation, login|
      login.should be_nil

      operation.password.should have_error("operation.error.password_required")
    end
  end

  it "requires IP address" do
    SaveLogin.create(params(
      active_at: Time.utc,
      email: "user@example.tld",
      password: "secret",
      token_digest: "abc"
    )) do |operation, login|
      login.should be_nil

      operation.ip_address
        .should have_error("operation.error.ip_address_required")
    end
  end

  it "requires valid email format" do
    SaveLogin.create(params(
      active_at: Time.utc,
      email: "user",
      ip_address: "1.2.3.4",
      password: "secret",
      token_digest: "abc"
    )) do |operation, login|
      login.should be_nil

      operation.email.should have_error("operation.error.email_invalid")
    end
  end
end
