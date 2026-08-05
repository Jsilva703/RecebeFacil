require "rails_helper"

RSpec.describe User, type: :model do
  let(:account) { Account.create!(name: "Acme") }

  let(:valid_attributes) do
    {
      account: account,
      name: "Jane Doe",
      username: "jane.doe",
      email: "jane@example.com",
      status: "active"
    }
  end

  describe "validations" do
    it "is valid with valid attributes" do
      user = described_class.new(valid_attributes)

      expect(user).to be_valid
    end

    it "is invalid without an account" do
      user = described_class.new(
        valid_attributes.merge(account: nil)
      )

      expect(user).not_to be_valid
      expect(user.errors[:account])
        .to include("must exist")
              .or include("can't be blank")
    end

    it "is invalid without a name" do
      user = described_class.new(
        valid_attributes.merge(name: nil)
      )

      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it "is invalid without an email" do
      user = described_class.new(
        valid_attributes.merge(email: nil)
      )

      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "is invalid with an unsupported status" do
      user = described_class.new(
        valid_attributes.merge(status: "blocked")
      )

      expect(user).not_to be_valid
      expect(user.errors[:status]).not_to be_empty
    end

    it "normalizes email before validation" do
      user = described_class.new(
        valid_attributes.merge(email: " Jane@Example.COM ")
      )

      user.valid?

      expect(user.email).to eq("jane@example.com")
    end

    it "does not accept a duplicate email" do
      described_class.create!(valid_attributes)

      duplicate_user = described_class.new(
        valid_attributes.merge(
          email: " JANE@example.com ",
          username: "john.doe"
        )
      )

      expect(duplicate_user).not_to be_valid
      expect(duplicate_user.errors[:email])
        .to include("has already been taken")
    end

    it "is invalid without a username" do
      user = described_class.new(
        valid_attributes.merge(username: nil)
      )

      expect(user).not_to be_valid
      expect(user.errors[:username]).to include("can't be blank")
    end

    it "normalizes username before validation" do
      user = described_class.new(
        valid_attributes.merge(username: " JSilva.703 ")
      )

      user.valid?

      expect(user.username).to eq("jsilva.703")
    end

    it "does not accept a duplicate username" do
      described_class.create!(valid_attributes)

      duplicate_user = described_class.new(
        valid_attributes.merge(
          email: "other@example.com",
          username: " JANE.DOE "
        )
      )

      expect(duplicate_user).not_to be_valid
      expect(duplicate_user.errors[:username])
        .to include("has already been taken")
    end

    it "accepts a username with letters, numbers, dots and underscores" do
      user = described_class.new(
        valid_attributes.merge(username: "jsilva.703_test")
      )

      expect(user).to be_valid
    end

    it "rejects a username containing spaces" do
      user = described_class.new(
        valid_attributes.merge(username: "jane doe")
      )

      expect(user).not_to be_valid
      expect(user.errors[:username]).not_to be_empty
    end

    it "rejects a username containing unsupported characters" do
      user = described_class.new(
        valid_attributes.merge(username: "jane@doe")
      )

      expect(user).not_to be_valid
      expect(user.errors[:username]).not_to be_empty
    end

    it "rejects a username without letters" do
      user = described_class.new(
        valid_attributes.merge(username: "703.123")
      )

      expect(user).not_to be_valid
      expect(user.errors[:username]).not_to be_empty
    end

    it "rejects a username shorter than 3 characters" do
      user = described_class.new(
        valid_attributes.merge(username: "ab")
      )

      expect(user).not_to be_valid
      expect(user.errors[:username]).not_to be_empty
    end

    it "rejects a username longer than 30 characters" do
      user = described_class.new(
        valid_attributes.merge(username: "a" * 31)
      )

      expect(user).not_to be_valid
      expect(user.errors[:username]).not_to be_empty
    end
  end
end