require "../../spec_helper"

describe Shield::SaveUserOptions do
  it "updates user options" do
    user_options = UserOptionsBox.create &.user_id(UserBox.create.id)

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

  it "requires login notification option" do
    SaveUserOptions.create(params(
      password_notify: true
    )) do |operation, user_options|
      user_options.should be_nil

      assert_invalid(operation.login_notify, " required")
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
