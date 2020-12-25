require "../../../spec_helper"

describe Shield::EmailConfirmationCurrentUser::Edit do
  it "renders edit page" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.browser_auth(email, password)

    response = client.exec(EmailConfirmationCurrentUser::Edit)

    response.body.should eq("EmailConfirmationCurrentUser::EditPage")
  end

  it "requires logged in" do
    response = ApiClient.exec(EmailConfirmationCurrentUser::Edit)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
