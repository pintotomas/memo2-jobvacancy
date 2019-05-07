require 'spec_helper'

describe JobOffer do
  subject(:job_offer) { described_class.new({}) }

  describe 'model' do
    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:title) }
    it { is_expected.to respond_to(:location) }
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:owner) }
    it { is_expected.to respond_to(:owner=) }
    it { is_expected.to respond_to(:created_on) }
    it { is_expected.to respond_to(:updated_on) }
    it { is_expected.to respond_to(:is_active) }
    it { is_expected.to respond_to(:validity_date) }
  end

  describe 'valid?' do
    it 'should be invalid when title is blank' do
      job_offer = described_class.new({})
      expect(job_offer).not_to be_valid
      expect(job_offer.errors).to have_key(:title)
    end

    it 'should be valid when title is not blank' do
      job_offer = described_class.new(title: 'a title')
      expect(job_offer).to be_valid
    end
    it 'should be valid when validity date is/isnt blank' do
      job_offer1 = described_class.new(title: 'a title')
      job_offer2 = described_class.new(title: 'a title', validity_date: '28/04/2019 04:05:06 PM')
      expect(job_offer2).to be_valid
      expect(job_offer1).to be_valid
    end
    it 'should be valid when validity date is in the correct format' do
      job_offer = described_class.new(title: 'a title', validity_date: '28/04/2019 04:05:06 PM')
      expect(job_offer).to be_valid
    end
  end
end
