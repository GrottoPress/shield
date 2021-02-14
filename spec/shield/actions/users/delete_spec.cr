require "../../../spec_helper"

describe Shield::Users::Delete do
  it "deletes user" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    user = UserFactory.create
    UserOptionsFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.browser_auth(email, password)

    response = client.exec(
      Users::Delete.with(user_id: user.id),
      user: {confirm_delete: true}
    )

    response.headers["X-User-ID"]?.should eq("user_id")
  end

  it "requires logged in" do
    user = UserFactory.create
    UserOptionsFactory.create &.user_id(user.id)

    response = ApiClient.exec(
      Users::Delete.with(user_id: user.id),
      user: {confirm_delete: true}
    )

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
