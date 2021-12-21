require "../../spec_helper"

describe Shield::CreateBearerLogin do
  it "creates bearer login" do
    user = UserFactory.create
    UserOptionsFactory.create &.user_id(user.id)

    CreateBearerLogin.create(
      params(name: "some token"),
      scopes: ["posts.index"],
      allowed_scopes: ["posts.update", "posts.index", "current_user.show"],
      user: user
    ) do |operation, bearer_login|
      bearer_login.should be_a(BearerLogin)

      bearer_login.try do |bearer_login|
        bearer_login.status.active?.should be_true
        bearer_login.inactive_at.should_not be_nil
      end

      operation.token.should_not be_empty
    end
  end
end
