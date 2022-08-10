require "../../../../../spec_helper"

describe Shield::Api::CurrentUser::OauthClients::Create do
  it "creates OAuth client" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.api_auth(email, password)

    response = client.exec(
      Api::CurrentUser::OauthClients::Create,
      oauth_client: {
        name: "Some Client",
        redirect_uri: "https://example.co/cb",
        public: false
      }
    )

    response.should send_json(
      200,
      {message: "action.current_user.oauth_client.create.success"}
    )
  end

  it "requires logged in" do
    response = ApiClient.exec(
      Api::CurrentUser::OauthClients::Create,
      oauth_client: {
        name: "Some Client",
        redirect_uri: "https://example.co/cb",
        public: false
      }
    )

    response.should send_json(401, logged_in: false)
  end
end
