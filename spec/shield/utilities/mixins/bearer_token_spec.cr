require "../../../spec_helper"

describe Shield::BearerToken do
  describe "#authenticate" do
    it "sets authorization header" do
      headers = HTTP::Headers.new
      BearerToken.new("abcdef", 1).authenticate(headers)

      headers["Authorization"]?.should eq("Bearer 1.abcdef")
    end
  end

  describe ".from_headers" do
    it "works" do
      headers = HTTP::Headers{"Authorization" => "Bearer 123.abcdef"}
      BearerToken.from_headers?(headers).should be_a(BearerToken)
    end

    it "rejects invalid header" do
      all_headers = [
        HTTP::Headers{"Authorization" => "bearer 123.abcdef"},
        HTTP::Headers{"Authorization" => "Bearer 123.abcdef ghi"},
        HTTP::Headers{"Authorization" => "Basic 123.abcdef"},
        HTTP::Headers{"Authorization" => "123.abcdef"},
        HTTP::Headers{"Authorization" => "Bearer "},
        HTTP::Headers{"Authorization" => "Bearer .abcdef"},
        HTTP::Headers{"Authorization" => "Bearer abcdef "},
        HTTP::Headers{"Authorization" => "Bearer 123"},
        HTTP::Headers{"Authorization" => "Bearer 123abc"},
      ]

      all_headers.each do |headers|
        BearerToken.from_headers?(headers).should be_nil
      end
    end
  end
end
