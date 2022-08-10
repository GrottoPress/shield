require "../../../../spec_helper"

describe Shield::OauthClients::Secret::Update do
  it "updates OAuth client" do
    password = "password4APASSWORD<"
    secret = "a1b2c3"

    user = UserFactory.create &.password(password)
    UserOptionsFactory.create &.user_id(user.id)
    oauth_client = OauthClientFactory.create &.user_id(user.id).secret(secret)

    oauth_client.secret_digest.should be_truthy

    oauth_client.secret_digest.try do |digest|
      Sha256Hash.new(secret).verify?(digest).should be_true
    end

    client = ApiClient.new
    client.browser_auth(user, password)

    response = client.exec(OauthClients::Secret::Update.with(
      oauth_client_id: oauth_client.id
    ))

    response.headers["X-OAuth-Client-ID"]?.should eq(oauth_client.id.to_s)

    oauth_client.reload.tap do |client|
      client.secret_digest.should be_truthy

      client.secret_digest.try do |digest|
        Sha256Hash.new(secret).verify?(digest).should be_false
      end
    end
  end

  it "requires logged in" do
    response = ApiClient.exec(OauthClients::Secret::Update.with(
      oauth_client_id: 22
    ))

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
