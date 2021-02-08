require "../../spec_helper"

describe Shield::StartEmailConfirmation do
  it "starts email confirmation for new user" do
    ip_address = Socket::IPAddress.new("1.2.3.4", 5)

    StartEmailConfirmation.create(
      params(email: "uSer@ex4mple.tld"),
      remote_ip: ip_address
    ) do |operation, email_confirmation|
      email_confirmation.should be_a(EmailConfirmation)
      operation.token.should_not be_empty

      email_confirmation.try(&.ip_address).should(eq ip_address.address)
    end
  end

  it "starts email confirmation for existing user" do
    ip_address = Socket::IPAddress.new("1.2.3.4", 5)

    user = UserFactory.create &.email("useR@examplE.tLd")

    StartEmailConfirmation.create(
      params(email: "user@domain.Tld"),
      user_id: user.id,
      remote_ip: ip_address
    ) do |operation, email_confirmation|
      email_confirmation.should be_a(EmailConfirmation)
      operation.token.should_not be_empty

      email_confirmation.try(&.ip_address).should(eq ip_address.address)
      email_confirmation.try(&.user_id).try &.should(eq user.id)
    end
  end

  it "requires email" do
    StartEmailConfirmation.create(
      remote_ip: Socket::IPAddress.new("1.2.3.4", 5)
    ) do |operation, email_confirmation|
      email_confirmation.should be_nil

      assert_invalid(operation.email, " required")
    end
  end

  it "rejects invalid email" do
    StartEmailConfirmation.create(
      params(email: "email"),
      remote_ip: Socket::IPAddress.new("1.2.3.4", 5)
    ) do |operation, email_confirmation|
      email_confirmation.should be_nil

      assert_invalid(operation.email, "is invalid")
    end
  end

  it "rejects existing email" do
    email = "user@example.tld"

    UserFactory.create &.email(email)

    StartEmailConfirmation.create(
      params(email: email),
      remote_ip: nil
    ) do |operation, email_confirmation|
      email_confirmation.should be_nil

      assert_invalid(operation.email, "already taken")
    end
  end

  it "requires valid IP address" do
    StartEmailConfirmation.create(
      params(email: "user@example.tld"),
      remote_ip: nil
    ) do |operation, email_confirmation|
      email_confirmation.should be_nil

      assert_invalid(operation.ip_address, "not be determined")
    end
  end

  it "sends email confirmation email" do
    StartEmailConfirmation.create(
      params(email: "user@example.tld"),
      remote_ip: Socket::IPAddress.new("1.2.3.4", 5)
    ) do |operation, email_confirmation|
      UserEmailConfirmationRequestEmail.new(operation).should_not be_delivered

      EmailConfirmationRequestEmail
        .new(operation, email_confirmation.not_nil!)
        .should(be_delivered)
    end
  end

  it "sends email even if email exists" do
    email = "user@example.tld"

    UserFactory.create &.email(email)

    StartEmailConfirmation.create(
      params(email: email),
      remote_ip: Socket::IPAddress.new("1.2.3.4", 5)
    ) do |operation, email_confirmation|
      email_confirmation.should be_nil
      UserEmailConfirmationRequestEmail.new(operation).should be_delivered
    end
  end
end
