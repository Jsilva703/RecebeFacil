class User < ApplicationRecord
  STATUSES = %w[active inactive suspended].freeze
  belongs_to :account

  before_validation :normalize_email

  validates :account, presence: true
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :status, presence: true, inclusion: { in: STATUSES }

  private

  def normalize_email
    self.email = email.to_s.strip.downcase if email.present?
  end
end