require "../../../../spec_helper"

describe Shield::Api::EmailConfirmationCurrentUser::Update do
  it "updates user" do
    email = "useR@ex4mple.tld"
    password = "password4APASSWORD<"
    new_level = User::Level.new(:author)

    user = UserFactory.create &.email(email)
      .level(:admin)
      .password(password)

    UserOptionsFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.api_auth(user, password)

    response = client.exec(
      Api::CurrentUser::Update,
      user: {level: new_level.to_s},
      user_options: {password_notify: true}
    )

    response.should send_json(200, {status: "success"})
    user.reload.level.should eq(new_level)
  end

  it "requires logged in" do
    response = ApiClient.exec(
      Api::CurrentUser::Update,
      user: {level: User::Level.new(:author).to_s},
      user_options: {login_notify: true}
    )

    response.should send_json(401, logged_in: false)
  end
end
