require 'spec_helper'

describe JobApplication do
  subject(:job_application) { described_class.new({}) }

  describe 'model' do
    it { is_expected.to respond_to(:applicant_email) }
    it { is_expected.to respond_to(:job_offer_id) }
  end

  describe 'initialize' do
    it 'should set applicant_email' do
      email = 'applicant@test.com'
      ja = described_class.new(email: email, job_offer_id: 0)
      expect(ja.applicant_email).to eq(email)
    end

    it 'should set job_offer' do
      offer = JobOffer.new(id: 1667)
      ja = described_class.new(email: 'applicant@test.com', job_offer_id: offer.id)
      expect(ja.job_offer_id).to eq(offer.id)
    end
  end

  describe 'valid?' do
    it 'should be valid when email is aMail@gmail.com and bio is present' do
      email = 'aMail@gmail.com'
      bio = 'this is my bio'
      ja = described_class.new(email: email, job_offer_id: JobOffer.new.id, bio: bio)
      expect(ja).to be_valid
    end

    it 'should not be valid when the email is empty' do
      ja = described_class.new(email: '', job_offer_id: JobOffer.new.id, bio: 'short bio')
      expect(ja).not_to be_valid
    end

    it 'should not be valid when the bio is empty' do
      ja = described_class.new(email: 'aMail@gmail.com', job_offer_id: JobOffer.new.id, bio: '')
      expect(ja).not_to be_valid
    end

    it 'should not be valid when the bio is over 500 characters' do
      bio = ''
      (1..501).each do |_i|
        bio += 'a'
      end
      ja = described_class.new(email: 'aMail@gmail.com', job_offer_id: JobOffer.new.id, bio: bio)
      expect(ja).not_to be_valid
    end

    it 'should be valid when the bio is exactly 500 characters' do
      bio = ''
      (1..500).each do |_i|
        bio += 'a'
      end
      ja = described_class.new(email: 'aMail@gmail.com', job_offer_id: JobOffer.new.id, bio: bio)
      expect(ja).to be_valid
    end

    it 'should not be valid when the email has a invalid format' do
      email =  'aBadMailArrobaGmail.com'
      ja = described_class.new(email: email, job_offer_id: JobOffer.new.id, bio: 'short bio')
      expect(ja).not_to be_valid
    end
    it 'should not be valid when the offer is already satisfied' do
      of = JobOffer.new(title: 'a title', satisfied: true,
                        validity_date: '2019-05-29', validity_time: '04:07')
      ja = described_class.new(email: 'a@t.com', job_offer_id: of.id, bio: 'a', offer: of)
      expect(ja).not_to be_valid
    end
  end

  describe 'process' do
    it 'should deliver contact info notification' do
      offer = JobOffer.new(id: 123)
      ja = described_class.new(email: 'applicant@test.com', job_offer_id: offer.id,
                               bio: 'short bio')
      expect(JobVacancy::App).to receive(:deliver).with(:notification, :contact_info_email, ja)
      ja.process(offer)
    end
  end
end
