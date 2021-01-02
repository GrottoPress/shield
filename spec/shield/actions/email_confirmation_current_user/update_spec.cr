require "../../../spec_helper"

describe Shield::EmailConfirmationCurrentUser::Update do
  it "updates user" do
    email = "user@example.tld"
    password = "password4APASSWORD<"
    new_level = User::Level.new(:author)

    user = UserBox.create &.email(email)
      .level(User::Level.new(:admin))
      .password_digest(BcryptHash.new(password).hash)

    client = ApiClient.new
    client.browser_auth(user, password)

    response = client.exec(EmailConfirmationCurrentUser::Update, user: {
      level: new_level.to_s
    })

    user.reload.level.should eq(new_level)
  end

  it "requires logged in" do
    response = ApiClient.exec(EmailConfirmationCurrentUser::Update, user: {
      level: User::Level.new(:author).to_s
    })

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
