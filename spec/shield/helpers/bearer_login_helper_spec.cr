require "../../spec_helper"

describe Shield::BearerLoginHelper do
  describe ".scope" do
    it "works" do
      BearerLoginHelper.scope(Api::Posts::Index).should eq("api.posts.index")
      BearerLoginHelper.scope(CurrentUser::Show).should eq("current_user.show")
    end
  end
end
