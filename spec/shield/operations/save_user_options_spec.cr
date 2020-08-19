require "../../spec_helper"

describe Shield::SaveUserOptions do
  it "requires user id" do
    SaveUserOptions.create(params(
      login_notify: true,
      password_notify: true
    )) do |operation, user_options|
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
