require "../../../spec_helper"

describe Shield::NotifyPasswordChangeIfSet do
  it "sends password change notification" do
    user = UserFactory.create &.password("password12U.password")

    params = nested_params(
      user: {
        password: "assword12U.passwor",
        password_notify: true,
      }
    )

    UpdateCurrentUserWithSettings.update(
      user,
      params,
      current_login: nil
    ) do |operation, updated_user|
      operation.saved?.should be_true

      PasswordChangeNotificationEmail
        .new(operation, updated_user)
        .should(be_delivered)
    end
  end

  it "does not send password change notification" do
    user = UserFactory.create &.password("password12U.password")

    params = nested_params(
      user: {
        password: "assword12U.passwor",
        password_notify: false,
      }
    )

    UpdateCurrentUserWithSettings.update(
      user,
      params,
      current_login: nil
    ) do |operation, updated_user|
      operation.saved?.should be_true

      PasswordChangeNotificationEmail
        .new(operation, updated_user)
        .should_not(be_delivered)
    end
  end
end
