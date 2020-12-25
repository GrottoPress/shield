require "../../../spec_helper"

describe Shield::Users::Update do
  it "updates user" do
    email = "user@example.tld"
    new_email = "newuser@domain.com.gh"
    password = "password4APASSWORD<"

    user = UserBox.create

    client = ApiClient.new
    client.browser_auth(email, password)

    response = client.exec(Users::Update.with(user_id: user.id), user: {
      email: new_email
    })

    response.headers["X-User-ID"]?.should eq(user.id.to_s)
  end

  it "requires logged in" do
    response = ApiClient.exec(Users::Update.with(user_id: 1_i64), user: {
      email: "user@email.com"
    })

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
