require "../../../spec_helper"

describe Shield::PwnedPasswords do
  describe "#pwned?" do
    it "accepts safe password" do
      PwnedPasswords.pwned?("msksieie565iww1id*slLF").should be_false
    end

    it "rejects unsafe password" do
      PwnedPasswords.pwned?("password").should be_true
    end
  end
end
