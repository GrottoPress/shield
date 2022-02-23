require "../../../../spec_helper"

describe Shield::CurrentUser::BearerLogins::Create do
  it "creates bearer login" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.browser_auth(email, password)

    response = client.exec(CurrentUser::BearerLogins::Create, bearer_login: {
      name: "some token",
      scopes: ["api.posts.index"]
    })

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Bearer-Login-ID"]?.should_not be_nil
  end

  it "requires logged in" do
    response = ApiClient.exec(CurrentUser::BearerLogins::Create, bearer_login: {
      name: "some token",
      scopes: ["api.posts.index"]
    })

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
