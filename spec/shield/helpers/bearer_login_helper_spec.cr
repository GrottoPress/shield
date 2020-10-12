require "../../spec_helper"

describe Shield::BearerLoginHelper do
  describe ".scope" do
    it "works" do
      BearerLoginHelper.scope(Posts::Index).should eq("posts.index")
      BearerLoginHelper.scope(CurrentUser::Show).should eq("current_user.show")
    end
  end

  describe ".bearer_token" do
    it "works" do
      BearerLoginHelper.bearer_token(1, "abcdef").should eq("1.abcdef")
    end
  end

  describe ".authorization_header" do
    it "works" do
      BearerLoginHelper.authorization_header(1, "abcdef")
        .should eq("Bearer 1.abcdef")
    end
  end

  describe ".token_from_headers" do
    it "works" do
      all_headers = [
        HTTP::Headers{"Authorization" => "Bearer 123.abcdef"},
        HTTP::Headers{"Authorization" => "Bearer  .abcdef"},
        HTTP::Headers{"Authorization" => "Bearer abcdef "},
        HTTP::Headers{"Authorization" => "Bearer 123"},
        HTTP::Headers{"Authorization" => "Bearer 123abc"},
      ]

      all_headers.each do |headers|
        BearerLoginHelper.token_from_headers(headers).should_not be_nil
      end
    end

    it "rejects invalid header" do
      all_headers = [
        HTTP::Headers{"Authorization" => "Bearer 123.abcdef ghi"},
        HTTP::Headers{"Authorization" => "Basic 123.abcdef"},
        HTTP::Headers{"Authorization" => "123.abcdef"},
        HTTP::Headers{"Authorization" => "Bearer "},
      ]

      all_headers.each do |headers|
        BearerLoginHelper.token_from_headers(headers).should be_nil
      end
    end
  end
end
