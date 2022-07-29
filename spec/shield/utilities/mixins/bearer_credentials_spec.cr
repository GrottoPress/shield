require "../../../spec_helper"

describe Shield::BearerCredentials do
  describe "#authenticate" do
    it "sets authorization header" do
      headers = HTTP::Headers.new
      BearerLoginCredentials.new("abcdef", 123).authenticate(headers)

      headers["Authorization"]?.should eq("Bearer MTIzOmFiY2RlZg")
    end
  end

  describe ".from_headers" do
    it "accepts valid header" do
      headers = HTTP::Headers{"Authorization" => "Bearer MTIzOmFiY2RlZg"}

      BearerLoginCredentials.from_headers?(headers)
        .should(be_a BearerLoginCredentials)
    end

    it "rejects invalid header" do
      all_headers = [
        HTTP::Headers{"Authorization" => "Bearer MTIzOmFiY2RlZg ghi"},
        HTTP::Headers{"Authorization" => "Basic MTIzOmFiY2RlZg"},
        HTTP::Headers{"Authorization" => "MTIzOmFiY2RlZg"},
        HTTP::Headers{"Authorization" => "Bearer "},
        HTTP::Headers{"Authorization" => "Bearer  OmFiY2RlZg"}, # :abcdef
        HTTP::Headers{"Authorization" => "Bearer YWJjZGVm "}, # abcdef
        HTTP::Headers{"Authorization" => "Bearer MTIz"}, # 123
        HTTP::Headers{"Authorization" => "Bearer MTIzYWJj"}, # 123abc
      ]

      all_headers.each do |headers|
        BearerLoginCredentials.from_headers?(headers).should be_nil
      end
    end
  end
end
