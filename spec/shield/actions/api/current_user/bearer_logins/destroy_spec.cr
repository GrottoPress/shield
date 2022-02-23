require "../../../../../spec_helper"

describe Shield::Api::CurrentUser::BearerLogins::Destroy do
  it "deletes bearer logins" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.api_auth(email, password)

    response = client.exec(Api::CurrentUser::BearerLogins::Destroy)

    response.should send_json(
      200,
      {message: "action.current_user.bearer_login.destroy.success"}
    )
  end

  it "requires logged in" do
    response = ApiClient.exec(Api::CurrentUser::BearerLogins::Destroy)

    response.should send_json(401, logged_in: false)
  end
end
