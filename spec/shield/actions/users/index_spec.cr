require "../../../spec_helper"

describe Shield::Users::Index do
  it "renders edit page" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.browser_auth(email, password)

    response = client.exec(Users::Index)

    response.body.should eq("Users::IndexPage")
  end

  it "requires logged in" do
    response = ApiClient.exec(Users::Index)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
