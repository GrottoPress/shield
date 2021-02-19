require "../../spec_helper"

describe Shield::SaveUserOptions do
  it "creates user options" do
    SaveUserOptions.create(
      params(
        login_notify: false,
        password_notify: true,
        bearer_login_notify: false
      ),
      user_id: UserFactory.create.id
    ) do |operation, user_options|
      user_options.should be_a(UserOptions)

      user_options = user_options.not_nil!

      user_options.login_notify.should be_false
      user_options.password_notify.should be_true
    end
  end

  it "updates user options" do
    user_options = UserOptionsFactory.create &.user_id(UserFactory.create.id)

    SaveUserOptions.update(
      user_options,
      params(login_notify: false, password_notify: true)
    ) do |operation, updated_user_options|
      updated_user_options.login_notify.should be_false
      updated_user_options.password_notify.should be_true
    end
  end

  it "requires user id" do
    SaveUserOptions.create(params(
      login_notify: true,
      password_notify: true
    )) do |operation, user_options|
      user_options.should be_nil

      assert_invalid(operation.user_id, " required")
    end
  end

  it "requires valid user id" do
    SaveUserOptions.create(
      params(login_notify: true, password_notify: true),
      user_id: 111
    ) do |operation, user_options|
      user_options.should be_nil

      assert_invalid(operation.user_id, "not exist")
    end
  end

  it "requires password notification option" do
    SaveUserOptions.create(params(
      login_notify: true
    )) do |operation, user_options|
      user_options.should be_nil

      assert_invalid(operation.password_notify, " required")
    end
  end
end
