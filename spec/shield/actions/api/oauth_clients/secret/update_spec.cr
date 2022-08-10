require "../../../../../spec_helper"

describe Shield::Api::OauthClients::Secret::Update do
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
    client.api_auth(user, password)

    response = client.exec(Api::OauthClients::Secret::Update.with(
      oauth_client_id: oauth_client.id
    ))

    response.should send_json(
      200,
      {message: "action.oauth_client.secret.update.success"}
    )

    oauth_client.reload.tap do |client|
      client.secret_digest.should be_truthy

      client.secret_digest.try do |digest|
        Sha256Hash.new(secret).verify?(digest).should be_false
      end
    end
  end

  it "requires logged in" do
    response = ApiClient.exec(Api::OauthClients::Secret::Update.with(
      oauth_client_id: 22
    ))

    response.should send_json(401, logged_in: false)
  end
end
