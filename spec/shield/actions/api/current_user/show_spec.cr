require "../../../../spec_helper"

describe Shield::Api::CurrentUser::Show do
  it "renders show page" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.api_auth(email, password)

    response = client.exec(Api::CurrentUser::Show)

    response.should send_json(200, {status: "success"})
  end

  it "requires logged in" do
    response = ApiClient.exec(Api::CurrentUser::Show)

    response.should send_json(401, logged_in: false)
  end
end
