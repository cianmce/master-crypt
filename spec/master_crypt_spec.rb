require "spec_helper"
require "securerandom"
require "pry"

describe MasterCrypt do
  describe "#VERSION" do
    it "has a version number" do
      expect(MasterCrypt::VERSION).not_to be nil
    end
  end

  let(:secrets) { ["$ecret1!", "s€cret2/", "5eçre73'"] }
  let(:secret_data) { "Super 5ecr€t Data - #{SecureRandom.hex}" }
  let(:encrypted_data) { subject.encrypt(secret_data, secrets) }

  describe "#encrypt" do
    context "with no secrets" do
      let(:secrets) { [] }

      it "raises an error" do
        expect { encrypted_data }.to raise_error("At least 1 secret is required")
      end
    end

    context "with blank secrets" do
      let(:secrets) { ["", ""] }

      it "raises an error" do
        expect { encrypted_data }.to raise_error("Secrets must not be blank")
      end
    end
  end

  describe "#decrypt" do
    it "uses any secret to decrypt data" do
      secrets.each do |secret|
        expect(subject.decrypt(encrypted_data, secret)).to eq(secret_data)
      end
    end
  end
end
