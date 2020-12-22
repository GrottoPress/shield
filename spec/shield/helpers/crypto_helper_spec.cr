require "../../spec_helper"

describe Shield::CryptoHelper do
  describe ".verify_and_decrypt" do
    it "verifies and decrypts ciphertext" do
      plaintext = "abcdef"

      ciphertext = CryptoHelper.encrypt_and_sign(plaintext)
      decrypted = CryptoHelper.verify_and_decrypt(ciphertext)

      decrypted.try(&.should eq(plaintext))
    end
  end

  describe ".verify_sha256?" do
    it "verifies unsalted SHA256" do
      plaintext = "abcdef"
      digest = CryptoHelper.hash_sha256(plaintext, salt: false)

      CryptoHelper.verify_sha256?("123456", digest).should be_false
      CryptoHelper.verify_sha256?(plaintext, digest).should be_true
    end

    it "verifies salted SHA256" do
      plaintext = "abcdef"
      digest = CryptoHelper.hash_sha256(plaintext)

      CryptoHelper.verify_sha256?("123456", digest).should be_false
      CryptoHelper.verify_sha256?(plaintext, digest).should be_true
    end
  end
end
