require "../../../../spec_helper"

describe Shield::CurrentUser::BearerLogins::New do
  it "renders new page" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.browser_auth(email, password)

    response = client.exec(CurrentUser::BearerLogins::New)

    response.body.should eq("CurrentUser::BearerLogins::NewPage")
  end

  it "requires logged in" do
    response = ApiClient.exec(CurrentUser::BearerLogins::New)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
