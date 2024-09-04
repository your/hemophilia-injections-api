require 'rails_helper'

RSpec.describe Injection, type: :model do
  subject { build(:injection) }

  context 'associations' do
    it { is_expected.to belong_to(:patient) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:dose_mm) }
    it { is_expected.to validate_presence_of(:lot_number) }
    it { is_expected.to validate_length_of(:lot_number).is_equal_to(6) }
    it { is_expected.to validate_presence_of(:drug_name) }
    it { is_expected.to validate_presence_of(:date) }

    context 'when validating uniqueness of lot_number' do
      before do
        create(:injection, lot_number: 'LOT123', drug_name: 'Factor A', date: Date.today)
      end

      it 'is valid with a unique lot_number for the same drug and date' do
        subject.lot_number = 'LOT456'
        subject.drug_name = 'Factor A'
        subject.date = Date.today
        expect(subject).to be_valid
      end

      it 'is not valid with a duplicate lot_number for the same drug and date' do
        subject.lot_number = 'LOT123' # Same as the existing one
        subject.drug_name = 'Factor A'
        subject.date = Date.today
        expect(subject).to_not be_valid
        expect(subject.errors[:lot_number]).to include("should be unique per drug and date")
      end
    end
  end
end
