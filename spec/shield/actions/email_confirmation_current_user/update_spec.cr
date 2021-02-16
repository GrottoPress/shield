require "../../../spec_helper"

describe Shield::EmailConfirmationCurrentUser::Update do
  it "updates user" do
    email = "user@example.tld"
    password = "password4APASSWORD<"
    new_level = User::Level.new(:author)

    user = UserFactory.create &.email(email)
      .level(:admin)
      .password(password)

    UserOptionsFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.browser_auth(user, password)

    response = client.exec(
      CurrentUser::Update,
      user: {level: new_level.to_s},
      user_options: {password_notify: true}
    )

    user.reload.level.should eq(new_level)
  end

  it "requires logged in" do
    response = ApiClient.exec(
      CurrentUser::Update,
      user: {level: User::Level.new(:author).to_s},
      user_options: {password_notify: true}
    )

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
