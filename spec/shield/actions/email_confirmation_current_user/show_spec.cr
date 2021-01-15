require "../../../spec_helper"

describe Shield::EmailConfirmationCurrentUser::Show do
  it "renders show page" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.browser_auth(email, password)

    response = client.exec(CurrentUser::Show)

    response.body.should eq("CurrentUser::ShowPage")
  end

  it "requires logged in" do
    response = ApiClient.exec(CurrentUser::Show)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
