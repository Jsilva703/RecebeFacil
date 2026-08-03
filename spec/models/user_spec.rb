require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid when associated with an account" do
      account = Account.create!(name: "Acme")
      user = described_class.new(
        account: account,
        name: "Jane Doe",
        email: "jane@example.com",
        status: "active"
      )

      expect(user).to be_valid
    end

    it "is invalid without an account" do
      user = described_class.new(name: "Jane Doe", email: "jane@example.com", status: "active")

      expect(user).not_to be_valid
      expect(user.errors[:account]).to include("must exist").or include("can't be blank")
    end

    it "is invalid without a name" do
      account = Account.create!(name: "Acme")
      user = described_class.new(account: account, email: "jane@example.com", status: "active")

      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it "is invalid without an email" do
      account = Account.create!(name: "Acme")
      user = described_class.new(account: account, name: "Jane Doe", status: "active")

      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "is invalid with an unsupported status" do
      account = Account.create!(name: "Acme")
      user = described_class.new(
        account: account,
        name: "Jane Doe",
        email: "jane@example.com",
        status: "blocked"
      )

      expect(user).not_to be_valid
      expect(user.errors[:status]).not_to be_empty
    end

    it "normalizes email before validation" do
      account = Account.create!(name: "Acme")
      user = described_class.new(account: account, name: "Jane Doe", email: " Jane@Example.COM ")

      user.valid?

      expect(user.email).to eq("jane@example.com")
    end

    it "does not accept duplicate email" do
      account = Account.create!(name: "Acme")
      described_class.create!(account: account, name: "Jane Doe", email: "jane@example.com")
      duplicate_user = described_class.new(account: account, name: "John Doe", email: " JANE@example.com ")

      expect(duplicate_user).not_to be_valid
      expect(duplicate_user.errors[:email]).to include("has already been taken")
    end
  end
end