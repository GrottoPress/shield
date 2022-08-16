require "../../../../spec_helper"

describe Shield::Api::OauthAuthorizations::Index do
  it "renders index page" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.api_auth(email, password)

    response = client.exec(Api::OauthAuthorizations::Index)

    response.should send_json(200, {status: "success"})
  end

  it "requires logged in" do
    response = ApiClient.exec(Api::OauthAuthorizations::Index)

    response.should send_json(401, logged_in: false)
  end
end
