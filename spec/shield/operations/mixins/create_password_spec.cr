require "../../../spec_helper"

describe Shield::CreatePassword do
  it "saves password" do
    password = "password12U-password"

    user = RegisterCurrentUser.create!(nested_params(
      user: {email: "user@example.tld", password: password},
      user_options: {login_notify: true, password_notify: true}
    ))

    BcryptHash.new(password)
      .verify?(user.password_digest)
      .should(be_true)
  end

  it "requires password" do
    RegisterCurrentUser.create(nested_params(
      user: {email: "user@domain.tld", password: ""},
      user_options: {login_notify: true, password_notify: true}
    )) do |operation, user|
      user.should be_nil

      assert_invalid(operation.password, " required")
      assert_valid(operation.password_digest, " required")
    end
  end

  it "does not send password change notification" do
    RegisterCurrentUser.create(nested_params(
      user: {email: "user@domain.tld", password: "password1=Apassword"},
      user_options: {login_notify: true, password_notify: false}
    )) do |operation, user|
      PasswordChangeNotificationEmail
        .new(operation, user.not_nil!)
        .should_not(be_delivered)
    end
  end
end
