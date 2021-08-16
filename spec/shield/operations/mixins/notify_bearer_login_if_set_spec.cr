require "../../../spec_helper"

describe Shield::NotifyBearerLoginIfSet do
  it "sends notification" do
    user = UserFactory.create

    UpdateUserWithSettings.update(
      user,
      bearer_login_notify: true,
      current_login: nil
    ) do |operation, updated_user|
      operation.saved?.should be_true
      updated_user.settings.login_notify.should be_true
    end

    CreateBearerLoginWithSettings.create(
      params(name: "some token"),
      scopes: ["posts.index"],
      allowed_scopes: ["posts.update", "posts.index", "current_user.show"],
      user: user
    ) do |operation, bearer_login|
      bearer_login.should be_a(BearerLogin)

      BearerLoginNotificationEmail.new(operation, bearer_login.not_nil!)
        .should(be_delivered)
    end
  end

  it "does not send notification" do
    user = UserFactory.create

    UpdateUserWithSettings.update(
      user,
      bearer_login_notify: false,
      current_login: nil
    ) do |operation, updated_user|
      operation.saved?.should be_true
      updated_user.settings.login_notify.should be_true
    end

    CreateBearerLoginWithSettings.create(
      params(name: "some token"),
      scopes: ["posts.index"],
      allowed_scopes: ["posts.update", "posts.index", "current_user.show"],
      user: user
    ) do |operation, bearer_login|
      bearer_login.should be_a(BearerLogin)

      BearerLoginNotificationEmail.new(operation, bearer_login.not_nil!)
        .should_not(be_delivered)
    end
  end
end
