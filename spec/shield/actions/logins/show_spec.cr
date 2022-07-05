require "../../../spec_helper"

describe Shield::Logins::Show do
  it "renders show page" do
    password = "password4APASSWORD<"

    user = UserFactory.create &.password(password)
    login = LoginFactory.create &.user_id(user.id)
    UserOptionsFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.browser_auth(user, password)

    response = client.exec(Logins::Show.with(login_id: login.id))

    response.body.should eq("Logins::ShowPage")
  end

  it "requires logged in" do
    response = ApiClient.exec(Logins::Show.with(login_id: 5))

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
