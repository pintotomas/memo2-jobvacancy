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

  describe 'process' do
    it 'should deliver contact info notification' do
      ja = described_class.new(email: 'applicant@test.com', job_offer_id: 1)
      expect(JobVacancy::App).to receive(:deliver).with(:notification, :contact_info_email, ja)
      ja.process
    end
  end
end
