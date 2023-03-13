require "../../../spec_helper"

private class SaveOauthClient < OauthClient::SaveOperation
  permit_columns :active_at,
    :inactive_at,
    :name,
    :secret_digest,
    :user_id

  include Shield::ValidateOauthClient
end

describe Shield::ValidateOauthClient do
  it "ensures redirect URIs are unique" do
    redirect_uri = "https://example.com/oauth/callback"

    user = UserFactory.create

    SaveOauthClient.create(
      params(
        active_at: Time.utc,
        name: "My Client",
        secret_digest: "a1b2c3",
        user_id: user.id
      ),
      redirect_uris: [redirect_uri, redirect_uri],
    ) do |_, oauth_client|
      oauth_client.should be_a(OauthClient)

      oauth_client.try do |client|
        client.redirect_uris.should eq([redirect_uri])
      end
    end
  end

  it "requires name" do
    user = UserFactory.create

    SaveOauthClient.create(
      params(
        active_at: Time.utc,
        secret_digest: "a1b2c3",
        user_id: user.id
      ),
      redirect_uris: ["https://example.com/oauth/callback"],
    ) do |operation, oauth_client|
      oauth_client.should be_nil

      operation.name.should have_error("operation.error.name_required")
    end
  end

  it "requires redirect URIs" do
    user = UserFactory.create

    SaveOauthClient.create(params(
      active_at: Time.utc,
      name: "Awesome Client",
      secret_digest: "a1b2c3",
      user_id: user.id
    )) do |operation, oauth_client|
      oauth_client.should be_nil

      operation.redirect_uris
        .should(have_error "operation.error.redirect_uris_required")
    end
  end

  it "requires user ID" do
    SaveOauthClient.create(
      params(
        active_at: Time.utc,
        name: "Awesome Client",
        secret_digest: "a1b2c3"
      ),
      redirect_uris: ["https://example.com/oauth/callback"],
    ) do |operation, oauth_client|
      oauth_client.should be_nil

      operation.user_id.should have_error("operation.error.user_id_required")
    end
  end

  it "requires redirect URIs not empty" do
    user = UserFactory.create

    SaveOauthClient.create(
      params(
        active_at: Time.utc,
        name: "Awesome Client",
        secret_digest: "a1b2c3",
        user_id: user.id
      ),
      redirect_uris: Array(String).new,
    ) do |operation, oauth_client|
      oauth_client.should be_nil

      operation.redirect_uris
        .should have_error("operation.error.redirect_uris_required")
    end
  end

  it "requires a valid name format" do
    user = UserFactory.create

    SaveOauthClient.create(
      params(
        active_at: Time.utc,
        name: "Awesome/Client",
        secret_digest: "a1b2c3",
        user_id: user.id
      ),
      redirect_uris: ["https://example.com/oauth/callback"],
    ) do |operation, oauth_client|
      oauth_client.should be_nil

      operation.name.should have_error("operation.error.name_invalid")
    end
  end

  it "rejects disallowed names" do
    user = UserFactory.create

    SaveOauthClient.create(
      params(
        active_at: Time.utc,
        name: "GrottoPress Client",
        secret_digest: "a1b2c3",
        user_id: user.id
      ),
      redirect_uris: ["https://example.com/oauth/callback"],
    ) do |operation, oauth_client|
      oauth_client.should be_nil

      operation.name.should have_error("operation.error.name_not_allowed")
    end
  end

  it "rejects duplicate name by same user" do
    name = "Awesome Client"

    user = UserFactory.create
    OauthClientFactory.create &.user_id(user.id).name(name)

    SaveOauthClient.create(
      params(
        active_at: Time.utc,
        name: name.upcase,
        secret_digest: "a1b2c3",
        user_id: user.id
      ),
      redirect_uris: ["https://example.com/oauth/callback"],
    ) do |operation, oauth_client|
      oauth_client.should be_nil

      operation.name.should have_error("operation.error.name_exists")
    end
  end

  it "accepts duplicate name by different user" do
    name = "Awesome Client"

    user = UserFactory.create &.email("user@example.tld")
    user_2 = UserFactory.create &.email("someone@example.net")

    OauthClientFactory.create &.user_id(user_2.id).name(name)

    SaveOauthClient.create(
      params(
        active_at: Time.utc,
        name: name,
        secret_digest: "a1b2c3",
        user_id: user.id
      ),
      redirect_uris: ["https://example.com/oauth/callback"],
    ) do |_, oauth_client|
      oauth_client.should be_a(OauthClient)
    end
  end

  it "requires valid redirect URI format" do
    user = UserFactory.create

    SaveOauthClient.create(
      params(
        active_at: Time.utc,
        name: "Awesome Client",
        secret_digest: "a1b2c3",
        user_id: user.id
      ),
      redirect_uris: ["https://example.com/oauth/#callback"],
    ) do |operation, oauth_client|
      oauth_client.should be_nil

      operation.redirect_uris
        .should(have_error "operation.error.redirect_uris_invalid")
    end
  end

  it "ensures user exists" do
    SaveOauthClient.create(
      params(
        active_at: Time.utc,
        name: "Awesome Client",
        secret_digest: "a1b2c3",
        user_id: 14
      ),
      redirect_uris: ["https://example.com/oauth/callback"],
    ) do |operation, oauth_client|
      oauth_client.should be_nil

      operation.user_id.should have_error("operation.error.user_not_found")
    end
  end

  it "limits redirect URIs to a set number" do
    Shield.temp_config(oauth_client_redirect_uris_max: 2) do
      user = UserFactory.create

      SaveOauthClient.create(
        params(
          active_at: Time.utc,
          name: "Awesome Client",
          secret_digest: "a1b2c3",
          user_id: user.id
        ),
        redirect_uris: [
          "https://example.com/oauth/1",
          "https://example.com/oauth/2",
          "https://example.com/oauth/3",
          "https://example.com/oauth/4",
        ],
      ) do |_, oauth_client|
        oauth_client.should be_a(OauthClient)

        oauth_client.try do |client|
          client.redirect_uris.should eq([
            "https://example.com/oauth/1",
            "https://example.com/oauth/2",
          ])
        end
      end
    end
  end
end
