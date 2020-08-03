require "../../spec_helper"

describe Shield::SaveUserOptions do
  it "requires user id" do
    SaveUserOptions.create(
      login_notify: true,
      password_notify: true
    ) do |operation, user_options|
      user_options.should be_nil

      operation
        .user_id
        .errors
        .find(&.includes? "not exist")
        .should_not(be_nil)
    end
  end

  it "requires login notification option" do
    SaveUserOptions.create(
      password_notify: true
    ) do |operation, user_options|
      user_options.should be_nil

      operation
        .login_notify
        .errors
        .find(&.includes? " required")
        .should_not(be_nil)
    end
  end

  it "requires password notification option" do
    SaveUserOptions.create(
      login_notify: true
    ) do |operation, user_options|
      user_options.should be_nil

      operation
        .password_notify
        .errors
        .find(&.includes? " required")
        .should_not(be_nil)
    end
  end
end
