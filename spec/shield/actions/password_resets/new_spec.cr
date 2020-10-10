require "../../../spec_helper"

describe Shield::PasswordResets::New do
  it "works" do
    response = ApiClient.exec(PasswordResets::New)
    response.should send_json(200, exit: 1)
  end

  it "requires logged out" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    UserBox.create &.email(email)
      .password_digest(CryptoHelper.hash_bcrypt(password))

    client = ApiClient.new

    response = client.exec(CurrentLogin::Create, login: {
      email: email,
      password: password
    })

    response.should send_json(200, session: 1)

    client.headers("Cookie": response.headers["Set-Cookie"])
    response = client.exec(PasswordResets::New)

    response.should send_json(200, logged_in: true)
  end
end
