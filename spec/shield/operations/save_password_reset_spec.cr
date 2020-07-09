require "../../spec_helper"

describe Shield::SavePasswordReset do
  it "saves password reset" do
    email = "user@example.tld"

    user = create_current_user!(email: email)

    SavePasswordReset.create(user_email: email) do |operation, password_reset|
      password_reset.should be_a(PasswordReset)
      operation.token.should_not be_empty
      password_reset.try &.token_hash.should_not(be_nil)
      password_reset.try &.user_id.should(eq user.id)
    end
  end

  it "rejects invalid email" do
    SavePasswordReset.create(user_email: "email") do |operation, password_reset|
      password_reset.should be_nil

      operation
        .user_email
        .errors
        .find(&.includes? "format invalid")
        .should_not(be_nil)
    end
  end

  it "sends guest email" do
    SavePasswordReset.create(
      user_email: "user@example.tld"
    ) do |operation, password_reset|
      password_reset.should be_nil
      GuestPasswordResetRequestEmail.new(operation).should be_delivered
    end
  end

  it "sends password reset request email" do
    email = "user@example.tld"

    create_current_user!(email: email)

    SavePasswordReset.create(user_email: email) do |operation, password_reset|
      GuestPasswordResetRequestEmail.new(operation).should_not be_delivered

      PasswordResetRequestEmail
        .new(operation, password_reset.not_nil!)
        .should(be_delivered)
    end
  end

  it "saves IP address" do
    email = "user@example.tld"

    create_current_user!(email: email)

    ip = Socket::IPAddress.new("127.0.0.1", 12345)

    password_reset = SavePasswordReset.create!(
      user_email: email,
      ip_address: ip
    )

    password_reset.ip_address.should eq(ip)
  end
end
