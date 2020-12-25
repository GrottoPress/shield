require "../../../../spec_helper"

describe Shield::Api::Users::Delete do
  it "deletes user" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    user = UserBox.create

    client = ApiClient.new
    client.api_auth(email, password)

    response = client.exec(Api::Users::Delete.with(user_id: user.id))

    response.should send_json(200, {status: "success"})
  end

  it "requires logged in" do
    user = UserBox.create

    response = ApiClient.exec(Api::Users::Delete.with(user_id: user.id))

    response.should send_json(401, logged_in: false)
  end
end
