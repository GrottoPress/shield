require "../../../../../spec_helper"

describe Shield::Api::CurrentUser::OauthClients::Delete do
  it "deletes OAuth clients" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.api_auth(email, password)

    response = client.exec(Api::CurrentUser::OauthClients::Delete)

    response.should send_json(
      200,
      {message: "action.current_user.oauth_client.destroy.success"}
    )
  end

  it "requires logged in" do
    response = ApiClient.exec(Api::CurrentUser::OauthClients::Delete)

    response.should send_json(401, logged_in: false)
  end
end
