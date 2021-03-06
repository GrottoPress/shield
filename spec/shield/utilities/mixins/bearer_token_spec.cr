require "../../../spec_helper"

describe Shield::BearerToken do
  describe "#to_header" do
    it "works" do
      BearerToken.new("abcdef", 1).to_header.should eq("Bearer 1.abcdef")
    end
  end

  describe ".from_headers" do
    it "works" do
      all_headers = [
        HTTP::Headers{"Authorization" => "Bearer 123.abcdef"},
        HTTP::Headers{"Authorization" => "Bearer  .abcdef"},
        HTTP::Headers{"Authorization" => "Bearer abcdef "},
        HTTP::Headers{"Authorization" => "Bearer 123"},
        HTTP::Headers{"Authorization" => "Bearer 123abc"},
      ]

      all_headers.each do |headers|
        BearerToken.from_headers(headers).should be_a(BearerToken)
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
        BearerToken.from_headers(headers).should be_nil
      end
    end
  end
end
