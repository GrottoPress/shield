require "../../../spec_helper"

describe Shield::Activate do
  it "sets active time" do
    user = UserFactory.create
    UserOptionsFactory.create &.user_id(user.id)

    CreateBearerLogin.create(
      params(name: "some token"),
      scopes: ["posts.index"],
      allowed_scopes: ["posts.update", "posts.index"],
      user: user
    ) do |operation, bearer_login|
      bearer_login.should be_a(BearerLogin)
      bearer_login.try &.active_at.should be_close(Time.utc, 1.second)
    end
  end

  it "sets given active time" do
    time = Time.utc(2016, 2, 15, 10, 20, 30)
    user = UserFactory.create
    UserOptionsFactory.create &.user_id(user.id)

    CreateBearerLogin.create(
      params(name: "some token"),
      active_at: time,
      scopes: ["posts.index"],
      allowed_scopes: ["posts.update", "posts.index"],
      user: user
    ) do |operation, bearer_login|
      bearer_login.should be_a(BearerLogin)
      bearer_login.try(&.active_at).should eq(time)
    end
  end
end
