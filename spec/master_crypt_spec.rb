require "spec_helper"
require "securerandom"
require "pry"

describe MasterCrypt do
  describe "#VERSION" do
    it "has a version number" do
      expect(MasterCrypt::VERSION).not_to be nil
    end
  end

  let(:secret_keys) { ["$ecret1! - #{SecureRandom.hex}", "s€cret2/ - #{SecureRandom.hex}", "5eçre73' - #{SecureRandom.hex}"] }
  let(:secret_data) { "Super 5ecr€t Data - #{SecureRandom.hex}" }
  let(:encrypted_data) { described_class.encrypt(secret_data, secret_keys) }
  let(:master_key) { "5ecr€t Master Key - #{SecureRandom.hex}" }

  subject { MasterCrypt.new(master_key) }

  describe "#master_key_decrypt" do
    let(:encrypted_data) { subject.master_key_encrypt(secret_data) }

    it "decrypts with master key" do
      expect(subject.master_key_decrypt(encrypted_data)).to eq(secret_data)
    end
  end

  describe "#master_key_encrypt" do
    let(:encrypted_data) { subject.master_key_encrypt(secret_data, secret_keys) }
    let(:invalid_secret_key) { "not the secret_key - #{SecureRandom.hex}" }

    it "decrypts with master key and non-master key" do
      ([master_key] + secret_keys).each do |secret_key|
        expect(described_class.decrypt(encrypted_data, secret_key)).to eq(secret_data)
      end
    end

    it "does not decrypt random key" do
      expect {
        described_class.decrypt(encrypted_data, invalid_secret_key)
      }.to raise_error(
        MasterCrypt::CryptoError, "Invalid secret key '#{invalid_secret_key}'"
      )
    end
  end

  describe "#encrypt" do
    context "with no secret_keys" do
      let(:secret_keys) { [] }

      it "raises an error" do
        expect { encrypted_data }.to raise_error(ArgumentError, "At least 1 secret key is required")
      end
    end

    context "with blank secret_keys" do
      let(:secret_keys) { ["", "secret_key", ""] }

      it "raises an error" do
        expect { encrypted_data }.to raise_error(ArgumentError, "Secret keys must not be blank")
      end
    end
  end

  describe "#decrypt" do
    it "uses any secret to decrypt data" do
      secret_keys.each do |secret|
        expect(described_class.decrypt(encrypted_data, secret)).to eq(secret_data)
      end
    end
  end
end
