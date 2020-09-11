require "../../../spec_helper"

describe Shield::PasswordResets::Create do
  it "works" do
    email = "user@example.tld"
    password = "password4APASSWORD<"

    UserBox.create &.email(email)
      .password_digest(CryptoHelper.hash_bcrypt(password, 4))

    response = ApiClient.exec(PasswordResets::Create, password_reset: {
      email: email
    })

    body(response)["status"]?.should eq(0)
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

    body(response)["session"]?.should_not be_nil

    client.headers("Cookie": response.headers["Set-Cookie"])
    response = client.exec(PasswordResets::Create, password_reset: {
      email: email
    })

    body(response)["status"]?.should be_nil
  end
end
