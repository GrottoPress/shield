require "../../spec_helper"

describe Shield::RegisterUser do
  email = "user@example.tld"
  password = "password12U password"

  it "creates user" do
    params = nested_params(
      user: {
        email: email,
        password: password,
        level: User::Level.new(:editor)
      },
      user_options: {
        login_notify: true,
        password_notify: true,
        bearer_login_notify: true,
        oauth_access_token_notify: true
      }
    )

    RegisterUser.create(params) do |_, user|
      user.should be_a(User)

      user.try do |user| # ameba:disable Lint/ShadowingOuterLocalVar
        user.email.should eq(email)
        BcryptHash.new(password).verify?(user.password_digest).should be_true
      end
    end
  end

  it "creates user options" do
    params = nested_params(
      user: {
        email: "user@example.tld",
        password: "password12U/password",
        level: User::Level.new(:editor)
      },
      user_options: {
        login_notify: true,
        password_notify: false,
        bearer_login_notify: true,
        oauth_access_token_notify: true
      }
    )

    user = RegisterUser.create!(params)
    user_options = user.options!

    user_options.login_notify.should be_true
    user_options.password_notify.should be_false
  end

  it "fails when nested operation fails" do
    params = nested_params(
      user: {email: "user@example.tld", password: "password12U password"},
      user_options: {
        login_notify: false,
        password_notify: false,
        bearer_login_notify: true,
        oauth_access_token_notify: true
      }
    )

    RegisterRegularCurrentUser2.create(params) do |operation, _|
      operation.saved?.should be_false

      # ameba:disable Performance/AnyInsteadOfEmpty
      UserQuery.new.any?.should be_false
    end
  end
end
