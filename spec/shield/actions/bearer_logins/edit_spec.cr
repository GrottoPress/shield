require "../../../spec_helper"

describe Shield::BearerLogins::Edit do
  it "renders edit page" do
    password = "password4APASSWORD<"

    user = UserFactory.create &.password(password)
    bearer_login = BearerLoginFactory.create &.user_id(user.id)
    UserOptionsFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.browser_auth(user, password)

    response = client.exec(BearerLogins::Edit.with(
      bearer_login_id: bearer_login.id
    ))

    response.body.should eq("BearerLogins::EditPage")
  end

  it "requires logged in" do
    response = ApiClient.exec(BearerLogins::Edit.with(bearer_login_id: 22))

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
