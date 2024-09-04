class Injection < ApplicationRecord
  belongs_to :patient

  validates :dose_mm, presence: true
  validates :lot_number, presence: true, length: { is: 6 },
    uniqueness: { scope: [:drug_name, :date], message: 'should be unique per drug and date' }
  validates :drug_name, presence: true
  validates :date, presence: true
end
