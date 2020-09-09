require "../../spec_helper"

describe Shield::StartEmailConfirmation do
  it "starts email confirmation for new user" do
    ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

    StartEmailConfirmation.submit(
      params(email: "user@example.tld"),
      remote_ip: ip_address
    ) do |operation, email_confirmation|
      email_confirmation.should be_a(EmailConfirmation)
      operation.token.should_not be_empty

      email_confirmation.try &.ip_address.should(eq ip_address.address)
    end
  end

  it "starts email confirmation for existing user" do
    ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

    user = create_current_user!(email: "user@example.tld")

    StartEmailConfirmation.submit(
      params(email: "user@domain.tld"),
      user_id: user.id,
      remote_ip: ip_address
    ) do |operation, email_confirmation|
      email_confirmation.should be_a(EmailConfirmation)
      operation.token.should_not be_empty

      email_confirmation.try &.ip_address.should(eq ip_address.address)
      email_confirmation.try &.user_id.try &.should(eq user.id)
    end
  end

  it "requires email" do
    StartEmailConfirmation.submit(
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    ) do |operation, email_confirmation|
      email_confirmation.should be_nil

      assert_invalid(operation.email, " required")
    end
  end

  it "rejects invalid email" do
    StartEmailConfirmation.submit(
      params(email: "email"),
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    ) do |operation, email_confirmation|
      email_confirmation.should be_nil

      assert_invalid(operation.email, "format is invalid")
    end
  end

  it "rejects existing email" do
    email = "user@example.tld"

    create_current_user!(email: email)

    StartEmailConfirmation.submit(
      params(email: email),
      remote_ip: nil
    ) do |operation, email_confirmation|
      email_confirmation.should be_nil

      assert_invalid(operation.email, "already taken")
    end
  end

  it "requires valid IP address" do
    StartEmailConfirmation.submit(
      params(email: "user@example.tld"),
      remote_ip: nil
    ) do |operation, email_confirmation|
      email_confirmation.should be_nil

      assert_invalid(operation.ip_address, "not be determined")
    end
  end

  it "sends email confirmation email" do
    StartEmailConfirmation.submit(
      params(email: "user@example.tld"),
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    ) do |operation, email_confirmation|
      UserEmailConfirmationRequestEmail.new(operation).should_not be_delivered

      EmailConfirmationRequestEmail
        .new(operation, email_confirmation.not_nil!)
        .should(be_delivered)
    end
  end

  it "sends email even if email exists" do
    email = "user@example.tld"

    create_current_user!(email: email)

    StartEmailConfirmation.submit(
      params(email: email),
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    ) do |operation, email_confirmation|
      email_confirmation.should be_nil
      UserEmailConfirmationRequestEmail.new(operation).should be_delivered
    end
  end
end
