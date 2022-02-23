require "../../../../../spec_helper"

describe Shield::Api::CurrentUser::BearerLogins::Create do
  it "creates bearer login" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.api_auth(email, password)

    response = client.exec(
      Api::CurrentUser::BearerLogins::Create,
      bearer_login: {name: "some token", scopes: ["api.posts.index"]}
    )

    response.should send_json(
      200,
      {message: "action.current_user.bearer_login.create.success"}
    )
  end

  it "requires logged in" do
    response = ApiClient.exec(
      Api::CurrentUser::BearerLogins::Create,
      bearer_login: {name: "some token", scopes: ["api.posts.index"]}
    )

    response.should send_json(401, logged_in: false)
  end
end
