require "../../../spec_helper"

private class SaveOauthClient < OauthClient::SaveOperation
  permit_columns :active_at,
    :inactive_at,
    :name,
    :redirect_uri,
    :secret_digest,
    :user_id

  include Shield::ValidateOauthClient
end

describe Shield::ValidateOauthClient do
  it "requires name" do
    user = UserFactory.create

    SaveOauthClient.create(params(
      active_at: Time.utc,
      redirect_uri: "https://example.com/oauth/callback",
      secret_digest: "a1b2c3",
      user_id: user.id
    )) do |operation, oauth_client|
      oauth_client.should be_nil

      operation.name.should have_error("operation.error.name_required")
    end
  end

  it "requires redirect URI" do
    user = UserFactory.create

    SaveOauthClient.create(params(
      active_at: Time.utc,
      name: "Awesome Client",
      secret_digest: "a1b2c3",
      user_id: user.id
    )) do |operation, oauth_client|
      oauth_client.should be_nil

      operation.redirect_uri
        .should(have_error "operation.error.redirect_uri_required")
    end
  end

  it "requires user ID" do
    SaveOauthClient.create(params(
      active_at: Time.utc,
      name: "Awesome Client",
      redirect_uri: "https://example.com/oauth/callback",
      secret_digest: "a1b2c3"
    )) do |operation, oauth_client|
      oauth_client.should be_nil

      operation.user_id.should have_error("operation.error.user_id_required")
    end
  end

  it "requires a valid name format" do
    user = UserFactory.create

    SaveOauthClient.create(params(
      active_at: Time.utc,
      name: "Awesome/Client",
      redirect_uri: "https://example.com/oauth/callback",
      secret_digest: "a1b2c3",
      user_id: user.id
    )) do |operation, oauth_client|
      oauth_client.should be_nil

      operation.name.should have_error("operation.error.name_invalid")
    end
  end

  it "rejects duplicate name by same user" do
    name = "Awesome Client"

    user = UserFactory.create
    OauthClientFactory.create &.user_id(user.id).name(name)

    SaveOauthClient.create(params(
      active_at: Time.utc,
      name: name,
      redirect_uri: "https://example.com/oauth/callback",
      secret_digest: "a1b2c3",
      user_id: user.id
    )) do |operation, oauth_client|
      oauth_client.should be_nil

      operation.name.should have_error("operation.error.name_exists")
    end
  end

  it "accepts duplicate name by different user" do
    name = "Awesome Client"

    user = UserFactory.create &.email("user@example.tld")
    user_2 = UserFactory.create &.email("someone@example.net")

    OauthClientFactory.create &.user_id(user_2.id).name(name)

    SaveOauthClient.create(params(
      active_at: Time.utc,
      name: name,
      redirect_uri: "https://example.com/oauth/callback",
      secret_digest: "a1b2c3",
      user_id: user.id
    )) do |_, oauth_client|
      oauth_client.should be_a(OauthClient)
    end
  end

  it "requires a valid redirect URI format" do
    user = UserFactory.create

    SaveOauthClient.create(params(
      active_at: Time.utc,
      name: "Awesome Client",
      redirect_uri: "https://example.com/oauth/#callback",
      secret_digest: "a1b2c3",
      user_id: user.id
    )) do |operation, oauth_client|
      oauth_client.should be_nil

      operation.redirect_uri
        .should(have_error "operation.error.redirect_uri_invalid")
    end
  end

  it "rejects duplicate redirect URI by same user" do
    redirect_uri = "https://example.com/oauth/callback"

    user = UserFactory.create
    OauthClientFactory.create &.user_id(user.id).redirect_uri(redirect_uri)

    SaveOauthClient.create(params(
      active_at: Time.utc,
      name: "Awesome Client",
      redirect_uri: redirect_uri,
      secret_digest: "a1b2c3",
      user_id: user.id
    )) do |operation, oauth_client|
      oauth_client.should be_nil

      operation.redirect_uri
        .should(have_error "operation.error.redirect_uri_exists")
    end
  end

  it "accepts duplicate redirect URI if existing client is inactive" do
    redirect_uri = "https://example.com/oauth/callback"

    user = UserFactory.create

    OauthClientFactory.create &.user_id(user.id)
      .redirect_uri(redirect_uri)
      .inactive_at(Time.utc)

    SaveOauthClient.create(params(
      active_at: Time.utc,
      name: "Another Client",
      redirect_uri: redirect_uri,
      secret_digest: "a1b2c3",
      user_id: user.id
    )) do |_, oauth_client|
      oauth_client.should be_a(OauthClient)
    end
  end

  it "accepts duplicate redirect URI by different user" do
    redirect_uri = "https://example.com/oauth/callback"

    user = UserFactory.create &.email("user@example.tld")
    user_2 = UserFactory.create &.email("someone@example.net")

    OauthClientFactory.create &.user_id(user_2.id).redirect_uri(redirect_uri)

    SaveOauthClient.create(params(
      active_at: Time.utc,
      name: "Awesome Client",
      redirect_uri: redirect_uri,
      secret_digest: "a1b2c3",
      user_id: user.id
    )) do |_, oauth_client|
      oauth_client.should be_a(OauthClient)
    end
  end

  it "ensures user exists" do
    SaveOauthClient.create(params(
      active_at: Time.utc,
      name: "Awesome Client",
      redirect_uri: "https://example.com/oauth/callback",
      secret_digest: "a1b2c3",
      user_id: 14
    )) do |operation, oauth_client|
      oauth_client.should be_nil

      operation.user_id.should have_error("operation.error.user_not_found")
    end
  end
end
