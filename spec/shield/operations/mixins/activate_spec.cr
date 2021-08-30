require "../../../spec_helper"

private class SaveBearerLogin < BearerLogin::SaveOperation
  permit_columns :user_id, :active_at, :name, :token_digest

  include Shield::Activate
end

describe Shield::Activate do
  it "sets active time" do
    user = UserFactory.create
    UserOptionsFactory.create &.user_id(user.id)

    SaveBearerLogin.create(
      params(name: "some token", user_id: user.id, token_digest: "abc"),
      scopes: ["posts.index"]
    ) do |operation, bearer_login|
      bearer_login.should be_a(BearerLogin)
      bearer_login.try &.active_at.should be_close(Time.utc, 2.seconds)
    end
  end

  it "sets given active time" do
    time = Time.utc(2016, 2, 15, 10, 20, 30)
    user = UserFactory.create
    UserOptionsFactory.create &.user_id(user.id)

    SaveBearerLogin.create(
      params(
        name: "some token",
        user_id: user.id,
        token_digest: "abc",
        active_at: time
      ),
      scopes: ["posts.index"]
    ) do |operation, bearer_login|
      bearer_login.should be_a(BearerLogin)
      bearer_login.try(&.active_at).should eq(time)
    end
  end
end
