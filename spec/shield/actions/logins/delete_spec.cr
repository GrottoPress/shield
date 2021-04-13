require "../../../spec_helper"

describe Shield::Logins::Delete do
  it "deletes login" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    user = UserFactory.create &.email(email).password(password)
    UserOptionsFactory.create &.user_id(user.id)
    login = LoginFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.browser_auth(user, password)

    response = client.exec(Logins::Delete.with(login_id: login.id))

    response.headers["X-Login-ID"]?.should eq(login.id.to_s)
  end

  it "requires logged in" do
    response = ApiClient.exec(Logins::Delete.with(login_id: 1_i64))

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
