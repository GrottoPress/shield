require "../../../spec_helper"

describe Shield::SaveUserSettings do
  it "saves settings" do
    params = nested_params(
      user: {
        email: "user@example.tld",
        password: "password12U.password",
        level: User::Level.new(:editor),
        bearer_login_notify: false,
        login_notify: false,
        password_notify: false,
      }
    )

    RegisterUserWithSettings.create(params) do |_, user|
      user.should be_a(User)

      user.try &.settings.bearer_login_notify?.should eq(false)
      user.try &.settings.login_notify.should eq(false)
      user.try &.settings.password_notify.should eq(false)
    end
  end

  context "create operations" do
    it "requires password_notify" do
      params = nested_params(
        user: {
          email: "user@example.tld",
          password: "password12U.password",
          level: User::Level.new(:editor),
          bearer_login_notify: false,
          login_notify: false,
        }
      )

      RegisterUserWithSettings.create(params) do |operation, user|
        user.should be_nil

        assert_invalid(
          operation.password_notify,
          "operation.error.password_notify_required"
        )
      end
    end

    it "requires bearer_login_notify" do
      params = nested_params(
        user: {
          email: "user@example.tld",
          password: "password12U.password",
          level: User::Level.new(:editor),
          password_notify: false,
          login_notify: false,
        }
      )

      RegisterUserWithSettings.create(params) do |operation, user|
        user.should be_nil

        assert_invalid(
          operation.bearer_login_notify,
          "operation.error.bearer_login_notify_required"
        )
      end
    end

    it "requires login_notify" do
      params = nested_params(
        user: {
          email: "user@example.tld",
          password: "password12U.password",
          level: User::Level.new(:editor),
          bearer_login_notify: false,
          password_notify: false,
        }
      )

      RegisterUserWithSettings.create(params) do |operation, user|
        user.should be_nil

        assert_invalid(
          operation.login_notify,
          "operation.error.login_notify_required"
        )
      end
    end
  end

  context "update operations" do
    it "does not require password_notify" do
      user = UserFactory.create

      UpdateUserWithSettings.update(
        user,
        params(bearer_login_notify: false, login_notify: false),
        current_login: nil
      ) do |operation, user|
        user.should be_a(User)
      end
    end

    it "does not require bearer_login_notify" do
      user = UserFactory.create

      UpdateUserWithSettings.update(
        user,
        params(password_notify: false, login_notify: false),
        current_login: nil
      ) do |operation, user|
        user.should be_a(User)
      end
    end

    it "does not require login_notify" do
      user = UserFactory.create

      UpdateUserWithSettings.update(
        user,
        params(bearer_login_notify: false, password_notify: false),
        current_login: nil
      ) do |operation, user|
        user.should be_a(User)
      end
    end
  end
end
