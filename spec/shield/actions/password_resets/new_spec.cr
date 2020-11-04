require "../../../spec_helper"

describe Shield::PasswordResets::New do
  it "works" do
    response = ApiClient.exec(PasswordResets::New)
    response.body.should eq("PasswordResets::NewPage")
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

    response.status.should eq(HTTP::Status::FOUND)

    client.headers("Cookie": response.headers["Set-Cookie"])
    response = client.exec(PasswordResets::New)

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"].should eq("true")
  end
end
