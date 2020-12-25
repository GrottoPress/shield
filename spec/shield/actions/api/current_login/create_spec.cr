require "../../../../spec_helper"

describe Shield::Api::CurrentLogin::Create do
  it "logs user in" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    user = UserBox.create &.email(email)
      .password_digest(CryptoHelper.hash_bcrypt(password))

    client = ApiClient.new

    response = client.exec(Api::CurrentLogin::Create, login: {
      email: email,
      password: password
    })

    response.should send_json(200, {status: "success"})
  end

  it "requires logged out" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    client = ApiClient.new
    client.api_auth(email, password)

    response = client.exec(Api::CurrentLogin::Create, login: {
      email: email,
      password: password
    })

    response.should send_json(200, logged_in: true)
  end
end
