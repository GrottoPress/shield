require "../../spec_helper"

describe Shield::CryptoHelper do
  describe ".verify_sha256?" do
    it "verifies unsalted SHA256" do
      plaintext = "abcdef"
      digest = CryptoHelper.hash_sha256(plaintext, salt_size: 0)

      CryptoHelper.verify_sha256?("123456", digest).should be_false
      CryptoHelper.verify_sha256?(plaintext, digest).should be_true
    end

    it "verifies salted SHA256" do
      plaintext = "abcdef"
      digest = CryptoHelper.hash_sha256(plaintext, salt_size: 10)

      CryptoHelper.verify_sha256?("123456", digest).should be_false
      CryptoHelper.verify_sha256?(plaintext, digest).should be_true
    end
  end
end
