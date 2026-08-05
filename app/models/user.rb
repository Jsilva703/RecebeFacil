class User < ApplicationRecord
  STATUSES = %w[active inactive suspended].freeze

  USERNAME_FORMAT =     /\A(?=.*[a-z])[a-z0-9](?:[a-z0-9._]*[a-z0-9])?\z/

  belongs_to :account
  before_validation :normalize_email, :normalize_username

  validates :account, presence: true
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :username, presence: true, length: { in: 3..30}, format: { with: USERNAME_FORMAT }, uniqueness: { case_sensitive: false }

  private

  def normalize_email
    self.email = email.to_s.strip.downcase if email.present?
  end

  def normalize_username
    self.username = username.to_s.strip.downcase if username.present?
  end
end