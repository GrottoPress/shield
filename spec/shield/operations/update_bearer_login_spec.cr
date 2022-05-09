require "../../spec_helper"

describe Shield::UpdateBearerLogin do
  it "creates bearer login" do
    new_name = "super duper secret"
    new_scopes = ["current_user.show"]

    user = UserFactory.create
    UserOptionsFactory.create &.user_id(user.id)

    bearer_login = BearerLoginFactory.create &.user_id(user.id)
      .name("secret")
      .scopes(["posts.update"])

    UpdateBearerLogin.update(
      bearer_login,
      params(name: new_name),
      scopes: new_scopes,
      allowed_scopes: ["posts.update", "current_user.show"]
    ) do |operation, updated_bearer_login|
      operation.saved?.should be_true

      updated_bearer_login.name.should eq(new_name)
      updated_bearer_login.scopes.should eq(new_scopes)
    end
  end
end
