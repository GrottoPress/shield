require "../../../../../spec_helper"

describe Shield::Api::CurrentUser::OauthAuthorizations::Destroy do
  it "ends OAuth authorizations" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.api_auth(email, password)

    response = client.exec(Api::CurrentUser::OauthAuthorizations::Destroy)

    response.should send_json(200, {
      message: "action.current_user.oauth_authorization.destroy.success"
    })
  end

  it "requires logged in" do
    response = ApiClient.exec(Api::CurrentUser::OauthAuthorizations::Destroy)

    response.should send_json(401, logged_in: false)
  end
end
