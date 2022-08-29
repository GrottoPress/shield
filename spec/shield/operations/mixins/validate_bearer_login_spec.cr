require "../../../spec_helper"

private class SaveBearerLogin < BearerLogin::SaveOperation
  permit_columns :user_id, :active_at, :name, :token_digest

  include Shield::ValidateBearerLogin
end

describe Shield::ValidateBearerLogin do
  it "ensures scopes are unique" do
    user = UserFactory.create

    SaveBearerLogin.create(
      params(
        name: "some token (number 2)",
        user_id: user.id,
        active_at: Time.utc,
        token_digest: "abc"
      ),
      scopes: [
        BearerScope.new(Api::Posts::Index).to_s,
        BearerScope.new(Api::Posts::New).to_s,
        BearerScope.new(Api::Posts::Index).to_s
      ]
    ) do |_, bearer_login|
      bearer_login.should be_a(BearerLogin)

      # ameba:disable Lint/ShadowingOuterLocalVar
      bearer_login.try do |bearer_login|
        bearer_login.scopes.should eq([
          BearerScope.new(Api::Posts::Index).to_s,
          BearerScope.new(Api::Posts::New).to_s
        ])
      end
    end
  end

  it "requires scopes" do
    user = UserFactory.create

    SaveBearerLogin.create(
      params(
        name: "some token",
        user_id: user.id,
        active_at: Time.utc,
        token_digest: "abc"
      ),
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      operation.scopes
        .should have_error("operation.error.bearer_scopes_required")
    end
  end

  it "requires user id" do
    SaveBearerLogin.create(
      params(
        name: "some token",
        active_at: Time.utc,
        token_digest: "abc"
      ),
      scopes: [BearerScope.new(Api::Posts::Index).to_s],
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      operation.user_id.should have_error("operation.error.user_id_required")
    end
  end

  it "requires valid user id" do
    SaveBearerLogin.create(
      params(
        name: "some token",
        user_id: 123,
        active_at: Time.utc,
        token_digest: "abc"
      ),
      scopes: [BearerScope.new(Api::Posts::Index).to_s],
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      operation.user_id.should have_error("operation.error.user_not_found")
    end
  end

  it "requires name" do
    user = UserFactory.create

    SaveBearerLogin.create(
      params(
        user_id: user.id,
        active_at: Time.utc,
        token_digest: "abc"
      ),
      scopes: [BearerScope.new(Api::Posts::Index).to_s],
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      operation.name.should have_error("operation.error.name_required")
    end
  end

  it "requires a valid name format" do
    user = UserFactory.create

    SaveBearerLogin.create(
      params(
        name: "in/valid;",
        user_id: user.id,
        active_at: Time.utc,
        token_digest: "abc"
      ),
      scopes: [BearerScope.new(Api::Posts::Index).to_s],
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      operation.name.should have_error("operation.error.name_invalid")
    end
  end

  it "rejects existing name by same user" do
    name = "some token"

    user = UserFactory.create
    BearerLoginFactory.create &.user_id(user.id).name(name)

    SaveBearerLogin.create(
      params(
        name: name,
        user_id: user.id,
        active_at: Time.utc,
        token_digest: "abc"
      ),
      scopes: [BearerScope.new(Api::Posts::Index).to_s],
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      operation.name.should have_error("operation.error.name_exists")
    end
  end

  it "accepts existing name by different user" do
    name = "a-screcret_token"

    user = UserFactory.create &.email("user@example.tld")
    user_2 = UserFactory.create &.email("someone@example.net")

    UserOptionsFactory.create &.user_id(user.id)
    UserOptionsFactory.create &.user_id(user_2.id)

    BearerLoginFactory.create &.user_id(user_2.id).name(name)

    SaveBearerLogin.create(
      params(
        name: name,
        user_id: user.id,
        active_at: Time.utc,
        token_digest: "abc"
      ),
      scopes: [BearerScope.new(Api::Posts::Index).to_s],
    ) do |_, bearer_login|
      bearer_login.should be_a(BearerLogin)
    end
  end

  it "requires scopes not empty" do
    user = UserFactory.create

    SaveBearerLogin.create(
      params(
        name: "some token",
        user_id: user.id,
        active_at: Time.utc,
        token_digest: "abc"
      ),
      scopes: Array(String).new,
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      operation.scopes.should have_error("operation.error.bearer_scopes_empty")
    end
  end

  it "requires valid scopes" do
    Shield.temp_config(bearer_login_scopes_allowed: [
      BearerScope.new(Api::Posts::New).to_s,
      BearerScope.new(Api::CurrentUser::Show).to_s
    ]) do
      user = UserFactory.create

      SaveBearerLogin.create(
        params(
          name: "some token",
          user_id: user.id,
          active_at: Time.utc,
          token_digest: "abc"
        ),
        scopes: [BearerScope.new(Api::Posts::Index).to_s],
      ) do |operation, bearer_login|
        bearer_login.should be_nil

        operation.scopes
          .should have_error("operation.error.bearer_scopes_invalid")
      end
    end
  end

  it "requires token digest" do
    user = UserFactory.create

    SaveBearerLogin.create(
      params(
        name: "some token",
        user_id: user.id,
        active_at: Time.utc
      ),
      scopes: [BearerScope.new(Api::Posts::Index).to_s],
    ) do |operation, bearer_login|
      bearer_login.should be_nil

      operation.token_digest.should have_error("operation.error.token_required")
    end
  end
end
