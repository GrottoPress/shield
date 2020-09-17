require "../../../spec_helper"

describe Shield::EmailConfirmations::Create do
  it "works" do
    response = ApiClient.exec(EmailConfirmations::Create, email_confirmation: {
      email: "user@domain.tld"
    })

    response.should send_json(200, exit: 0)
  end

  it "requires logged out" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    UserBox.create &.email(email)
      .password_digest(CryptoHelper.hash_bcrypt(password, 4))

    client = ApiClient.new

    response = client.exec(Logins::Create, login: {
      email: email,
      password: password
    })

    response.should send_json(200, session: 1)

    client.headers("Cookie": response.headers["Set-Cookie"])
    response = client.exec(EmailConfirmations::Create, email_confirmation: {
      email: "user@domain.tld"
    })

    response.should send_json(200, logged_in: true)
  end
end
