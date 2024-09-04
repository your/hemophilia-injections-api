class Patient < ApplicationRecord
  has_many :injections

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :date_of_birth, presence: true
  validates :api_key, presence: true, uniqueness: true

  before_validation :assign_api_key, on: :create

  private

  def assign_api_key
    self.api_key = SecureRandom.hex(16)
  end
end
