require 'rails_helper'

RSpec.describe Patient, type: :model do
  subject { build(:patient) }

  context 'associations' do
    it { is_expected.to have_many(:injections) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:date_of_birth) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end

  context 'on create' do
    let(:random_api_key) { SecureRandom.hex(16) }

    before do
      subject.api_key = nil
      allow(SecureRandom).to receive(:hex).with(16).and_return(random_api_key)
    end

    it 'saves it with a randomly generated api_key' do
      expect { subject.save }.to change { subject.api_key }
        .from(nil)
        .to(random_api_key)
    end
  end

  describe '#adherence_score' do
    let(:patient) { create(:patient, created_at: Date.new(2024, 1, 1)) }
    let(:treatment_schedule_days) { 3 }

    context 'when there are all the expected injections' do
      before do
        create(:injection, patient:, date: Date.new(2024, 1, 1))
        create(:injection, patient:, date: Date.new(2024, 1, 4))
        create(:injection, patient:, date: Date.new(2024, 1, 7))
        create(:injection, patient:, date: Date.new(2024, 1, 10))
      end

      it 'calculates the correct adherence score' do
        travel_to(Date.new(2024, 1, 12)) do
          expect(patient.adherence_score(treatment_schedule_days)).to eq(100.0)
        end
      end
    end

    context 'when there are fewer on time injections than actual and expected' do
      before do
        create(:injection, patient:, date: Date.new(2024, 1, 1))
        create(:injection, patient:, date: Date.new(2024, 1, 4))
        create(:injection, patient:, date: Date.new(2024, 1, 6)) # not on time
        create(:injection, patient:, date: Date.new(2024, 1, 10))
        create(:injection, patient:, date: Date.new(2024, 1, 13))
        create(:injection, patient:, date: Date.new(2024, 1, 16))
        create(:injection, patient:, date: Date.new(2024, 1, 19))
        create(:injection, patient:, date: Date.new(2024, 1, 22))
        create(:injection, patient:, date: Date.new(2024, 1, 26)) # not on time
        create(:injection, patient:, date: Date.new(2024, 1, 30)) # not on time
        create(:injection, patient:, date: Date.new(2024, 1, 31))
      end

      it 'calculates the correct adherence score' do
        travel_to(Date.new(2024, 2, 1)) do
          expect(patient.adherence_score(treatment_schedule_days)).to eq(73.0)
        end
      end
    end

    context 'when there are fewer actual injections than expected' do
      before do
        create(:injection, patient:, date: Date.new(2024, 1, 1))
        create(:injection, patient:, date: Date.new(2024, 1, 4))
      end

      it 'calculates the correct adherence score' do
        travel_to(Date.new(2024, 1, 12)) do
          expect(patient.adherence_score(treatment_schedule_days)).to eq(50.0)
        end
      end
    end

    context 'when there are no expected injections' do
      it 'returns 0 for adherence score' do
        expect(patient.adherence_score(treatment_schedule_days)).to eq(0.0)
      end
    end
  end
end
