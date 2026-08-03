require "rails_helper"

RSpec.describe Account, type: :model do
  describe "validations" do
    it "is valid with the required fields" do
      account = described_class.new(name: "Acme", status: "active")

      expect(account).to be_valid
    end

    it "is invalid without a name" do
      account = described_class.new(status: "active")

      expect(account).not_to be_valid
      expect(account.errors[:name]).to include("can't be blank")
    end

    it "is invalid with an unsupported status" do
      account = described_class.new(name: "Acme", status: "blocked")

      expect(account).not_to be_valid
      expect(account.errors[:status]).not_to be_empty
    end
  end
end