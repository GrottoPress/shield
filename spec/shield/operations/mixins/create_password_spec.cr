require "../../../spec_helper"

describe Shield::CreatePassword do
  it "saves password" do
    password = "password12U-password"

    user = RegisterCurrentUser.create!(params(
      email: "user@example.tld",
      password: password,
      password_confirmation: password,
      login_notify: true,
      password_notify: true
    ))

    CryptoHelper.verify_bcrypt?(password, user.password_digest).should be_true
  end

  it "requires password" do
    RegisterCurrentUser.create(params(
      email: "user@domain.tld",
      password: "",
      password_confirmation: "",
      login_notify: true,
      password_notify: true,
    )) do |operation, user|
      user.should be_nil

      assert_invalid(operation.password, " required")
      assert_valid(operation.password_digest, " required")
    end
  end

  it "does not send password change notification" do
    password = "password1=Apassword"

    RegisterCurrentUser.create(params(
      email: "user@domain.tld",
      password: password,
      password_confirmation: password,
      login_notify: true,
      password_notify: false,
    )) do |operation, user|
      PasswordChangeNotificationEmail
        .new(operation, user.not_nil!)
        .should_not(be_delivered)
    end
  end
end
