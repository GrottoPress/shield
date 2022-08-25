require "../../spec_helper"

describe Shield::SaveUserOptions do
  it "creates user options" do
    SaveUserOptions.create(
      params(
        login_notify: false,
        oauth_access_token_notify: false,
        password_notify: true,
        bearer_login_notify: false
      ),
      user_id: UserFactory.create.id
    ) do |_, user_options|
      user_options.should be_a(UserOptions)

      user_options = user_options.not_nil!

      user_options.bearer_login_notify.should be_false
      user_options.login_notify.should be_false
      user_options.oauth_access_token_notify.should be_false
      user_options.password_notify.should be_true
    end
  end

  it "updates user options" do
    user_options = UserOptionsFactory.create &.user_id(UserFactory.create.id)

    SaveUserOptions.update(
      user_options,
      params(login_notify: false, password_notify: true)
    ) do |_, updated_user_options|
      updated_user_options.login_notify.should be_false
      updated_user_options.password_notify.should be_true
    end
  end

  it "requires user id" do
    SaveUserOptions.create(params(
      bearer_login_notify: false,
      login_notify: true,
      oauth_access_token_notify: false,
      password_notify: true
    )) do |operation, user_options|
      user_options.should be_nil

      operation.user_id.should have_error("operation.error.user_id_required")
    end
  end

  it "requires valid user id" do
    SaveUserOptions.create(
      params(
        bearer_login_notify: false,
        login_notify: true,
        oauth_access_token_notify: false,
        password_notify: true
      ),
      user_id: 111
    ) do |operation, user_options|
      user_options.should be_nil

      operation.user_id.should have_error("operation.error.user_not_found")
    end
  end

  it "requires password notification option" do
    SaveUserOptions.create(params(
      bearer_login_notify: false,
      login_notify: true,
      oauth_access_token_notify: false
    )) do |operation, user_options|
      user_options.should be_nil

      operation.password_notify
        .should have_error("operation.error.password_notify_required")
    end
  end

  it "requires login notification option" do
    SaveUserOptions.create(params(
      bearer_login_notify: false,
      oauth_access_token_notify: false,
      password_notify: true
    )) do |operation, user_options|
      user_options.should be_nil

      operation.login_notify
        .should have_error("operation.error.login_notify_required")
    end
  end

  it "requires bearer login notification option" do
    SaveUserOptions.create(params(
      login_notify: true,
      oauth_access_token_notify: false,
      password_notify: true
    )) do |operation, user_options|
      user_options.should be_nil

      operation.bearer_login_notify
        .should have_error("operation.error.bearer_login_notify_required")
    end
  end

  it "requires OAuth access token notification option" do
    SaveUserOptions.create(params(
      bearer_login_notify: false,
      login_notify: true,
      password_notify: true
    )) do |operation, user_options|
      user_options.should be_nil

      operation.oauth_access_token_notify
        .should(have_error "operation.error.oauth_access_token_notify_required")
    end
  end
end
