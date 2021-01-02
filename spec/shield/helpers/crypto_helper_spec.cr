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
end
