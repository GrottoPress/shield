require "../../../spec_helper"

describe Shield::CreatePassword do
  it "saves password" do
    password = "password12U-password"

    user = RegisterRegularCurrentUser.create!(nested_params(
      user: {email: "user@example.tld", password: password},
      user_options: {
        login_notify: true,
        password_notify: true,
        bearer_login_notify: true
      }
    ))

    BcryptHash.new(password)
      .verify?(user.password_digest)
      .should(be_true)
  end

  it "requires password" do
    RegisterRegularCurrentUser.create(nested_params(
      user: {email: "user@domain.tld", password: ""},
      user_options: {
        login_notify: true,
        password_notify: true,
        bearer_login_notify: true
      }
    )) do |operation, user|
      user.should be_nil

      assert_invalid(operation.password, " required")
      assert_valid(operation.password_digest, " required")
    end
  end
end
