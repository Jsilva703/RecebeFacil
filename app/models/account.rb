class Account < ApplicationRecord
  STATUSES = %w[active inactive suspended].freeze
  has_many :users

  validates :name, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }
end