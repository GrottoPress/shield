require "../../../../spec_helper"

describe Shield::Api::CurrentUser::Update do
  it "updates user" do
    email = "user@example.tld"
    new_email = "newuser@domain.com.gh"
    password = "password4APASSWORD<"

    user = UserBox.create &.email(email)
      .password_digest(CryptoHelper.hash_bcrypt(password))

    client = ApiClient.new
    client.api_auth(user, password)

    response = client.exec(Api::CurrentUser::Update, user: {email: new_email})

    response.should send_json(200, {status: "success"})
    user.reload.email.should eq(new_email)
  end

  it "requires logged in" do
    response = ApiClient.exec(Api::CurrentUser::Update, user: {
      email: "user@email.com"
    })

    response.should send_json(401, logged_in: false)
  end
end
