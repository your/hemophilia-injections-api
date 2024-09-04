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
end
