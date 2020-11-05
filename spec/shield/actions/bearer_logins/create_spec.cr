require "../../../spec_helper"

describe Shield::BearerLogins::Create do
  it "works" do
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
    response = client.exec(BearerLogins::Create, bearer_login: {
      name: "some token",
      scopes: ["posts.index"],
      all_scopes: ["posts.update", "posts.index"],
      user_id: UserBox.create.id
    })

    response.body.should eq("BearerLogins::NewPage")
  end

  it "requires logged in" do
    response = ApiClient.exec(BearerLogins::Create, bearer_login: {
      name: "some token",
      scopes: ["posts.index"],
      all_scopes: ["posts.update", "posts.index"],
      user_id: UserBox.create.id
    })

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"].should eq("false")
  end
end
