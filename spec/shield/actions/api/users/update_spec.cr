require "../../../../spec_helper"

describe Shield::Api::Users::Update do
  it "updates user" do
    email = "user@example.tld"
    new_email = "newuser@domain.com.gh"
    password = "password4APASSWORD<"

    user = UserBox.create

    client = ApiClient.new
    client.api_auth(email, password)

    response = client.exec(Api::Users::Update.with(user_id: user.id), user: {
      email: new_email
    })

    response.should send_json(200, {status: "success"})
  end

  it "requires logged in" do
    response = ApiClient.exec(Api::Users::Update.with(user_id: 1_i64), user: {
      email: "user@email.com"
    })

    response.should send_json(401, logged_in: false)
  end
end
