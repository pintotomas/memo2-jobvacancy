require 'spec_helper'
require 'byebug'

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
    it { is_expected.to respond_to(:validity_time) }
    it { is_expected.to respond_to(:satisfied) }
    it { is_expected.to respond_to(:experience) }
  end

  describe 'valid?' do
    it 'should be invalid when title is blank' do
      job_offer = described_class.new({})
      expect(job_offer).not_to be_valid
      expect(job_offer.errors).to have_key(:title)
    end

    it 'should be valid when title is not blank' do
      job_offer = described_class.new(title: 'a title')
      job_offer.valid?
      expect(job_offer).to be_valid
    end
    it 'should be valid when validity date is/isnt blank' do
      job_offer1 = described_class.new(title: 'a title')
      job_offer2 = described_class.new(title: 'a title',
                                       validity_date: '2019-05-29', validity_time: '04:06')
      expect(job_offer2).to be_valid
      expect(job_offer1).to be_valid
    end
    it 'should be valid when validity date is in the correct format' do
      job_offer = described_class.new(title: 'a title',
                                      validity_date: '2019-05-29', validity_time: '04:07')
      expect(job_offer).to be_valid
    end
    it 'should be invalid when validity date is in the incorrect format' do
      job_offer = described_class.new(title: 'a title',
                                      validity_date: '2019-05-29', validity_time: '04:05')
      expect(job_offer).to be_valid
    end
  end

  describe 'expired?' do
    it 'should not be expired if validity date is tomorrow' do
      job_offer = described_class.new(title: 'a title',
                                      validity_date: Date.today.next_day.strftime,
                                      validity_time: '04:05',
                                      updated_on: Date.today)
      expect(job_offer.expired_offer?).to eq false
    end
    it 'should be expired if validity date was yesterday' do
      job_offer = described_class.new(title: 'a title',
                                      validity_date: Date.today.prev_day.strftime,
                                      validity_time: '04:05',
                                      updated_on: Date.today)
      expect(job_offer.expired_offer?).to eq true
    end
  end

  describe 'satisfied?' do
    it 'shouldnt be satisfied when it was just created' do
      job_offer = described_class.new(title: 'a title',
                                      validity_date: Date.today.next_day.strftime,
                                      validity_time: '04:05',
                                      updated_on: Date.today)
      expect(job_offer.satisfied?).to eq false
    end

    it 'should be satisfied after marking it as satisfied' do
      job_offer = described_class.new(title: 'a title',
                                      validity_date: Date.today.next_day.strftime,
                                      validity_time: '04:05',
                                      updated_on: Date.today)
      job_offer.satisfy
      expect(job_offer.satisfied?).to eq true
    end

    it 'satisfy an offer two times should raise error' do
      job_offer = described_class.new(title: 'a title', validity_date: Date.today.next_day.strftime,
                                      validity_time: '04:05', updated_on: Date.today)
      job_offer.satisfy
      expect { job_offer.satisfy }.to raise_error(AlreadySatisfiedError)
    end
    it 'unsatisfy a satisfied offer' do
      job_offer = described_class.new(title: 'a title', validity_date: Date.today.next_day.strftime,
                                      validity_time: '04:05', updated_on: Date.today)
      job_offer.satisfy
      job_offer.unsatisfy
      expect(job_offer.satisfied?).to eq false
    end
    it 'unsatisfy an offer that is not satisfied' do
      job_offer = described_class.new(title: 'a title', validity_date: Date.today.next_day.strftime,
                                      validity_time: '04:05', updated_on: Date.today)
      expect { job_offer.unsatisfy }.to raise_error(NotSatisfiedError)
    end
    it 'unsatisfy an offer that has expired due to validity date' do
      job_offer = described_class.new(title: 'a title', validity_date: Date.today.prev_day.strftime,
                                      validity_time: '04:05', updated_on: Date.today)
      expect { job_offer.unsatisfy }.to raise_error(CantUnsatisfyExpiredOffer)
    end
    it 'unsatisfy an offer that has expired because its too old' do
      job_offer = described_class.new(title: 'a title', updated_on: Date.new(2013, 2, 2))
      expect { job_offer.unsatisfy }.to raise_error(CantUnsatisfyOldOffer)
    end
    it 'satisfy an offer that has expired because its too old' do
      job_offer = described_class.new(title: 'a title', updated_on: Date.new(2013, 2, 2))
      expect { job_offer.satisfy }.to raise_error(CantSatisfyOldOffer)
    end
    # Preguntar, si expiro, deberia setearse como satisfecha automaticamente?
    it 'satisfy an offer that has expired due to validity date' do
      job_offer = described_class.new(title: 'a title', validity_date: Date.today.prev_day.strftime,
                                      validity_time: '04:05', updated_on: Date.today)
      expect { job_offer.satisfy }.to raise_error(CantSatisfyExpiredOffer)
    end
  end

  describe 'experience' do
    it 'job offer should be able to be created with experience' do
      job_offer = described_class.new(title: 'a title',
                                      validity_date: Date.today.next_day.strftime,
                                      validity_time: '04:05',
                                      experience: 1,
                                      updated_on: Date.today)
      expect(job_offer.experience).to eq 1
    end

    it 'job offer should be able to be created without experience' do
      job_offer = described_class.new(title: 'a title',
                                      validity_date: Date.today.next_day.strftime,
                                      validity_time: '04:05',
                                      updated_on: Date.today)
      expect(job_offer.valid?).to eq true
    end
  end
end
