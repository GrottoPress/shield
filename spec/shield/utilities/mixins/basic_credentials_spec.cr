require "../../../spec_helper"

private struct BasicCredentials
  include Shield::BasicCredentials

  def initialize(@password : String, @id : Int32)
  end
end

describe Shield::BasicCredentials do
  describe "#authenticate" do
    it "sets authorization header" do
      headers = HTTP::Headers.new
      BasicCredentials.new("abcdef", 123).authenticate(headers)

      headers["Authorization"]?.should eq("Basic MTIzOmFiY2RlZg")
    end
  end

  describe ".from_headers" do
    it "accepts valid header" do
      headers = HTTP::Headers{"Authorization" => "Basic MTIzOmFiY2RlZg"}

      BasicCredentials.from_headers?(headers)
        .should(be_a BasicCredentials)
    end

    it "rejects invalid header" do
      all_headers = [
        HTTP::Headers{"Authorization" => "Basic MTIzOmFiY2RlZg ghi"},
        HTTP::Headers{"Authorization" => "Bearer MTIzOmFiY2RlZg"},
        HTTP::Headers{"Authorization" => "MTIzOmFiY2RlZg"},
        HTTP::Headers{"Authorization" => "Basic "},
        HTTP::Headers{"Authorization" => "Basic  OmFiY2RlZg"}, # :abcdef
        HTTP::Headers{"Authorization" => "Basic YWJjZGVm "}, # abcdef
        HTTP::Headers{"Authorization" => "Basic MTIz"}, # 123
        HTTP::Headers{"Authorization" => "Basic MTIzYWJj"}, # 123abc
      ]

      all_headers.each do |headers|
        BasicCredentials.from_headers?(headers).should be_nil
      end
    end
  end
end
