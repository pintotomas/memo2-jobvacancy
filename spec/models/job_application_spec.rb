require 'spec_helper'

describe JobApplication do
  describe 'model' do
    it { is_expected.to respond_to(:applicant_email) }
    it { is_expected.to respond_to(:job_offer) }
  end

  describe 'create_for' do
    it 'should set applicant_email' do
      email = 'applicant@test.com'
      ja = described_class.create_for(email, JobOffer.new)
      expect(ja.applicant_email).to eq(email)
    end

    it 'should set job_offer' do
      offer = JobOffer.new
      ja = described_class.create_for('applicant@test.com', offer)
      expect(ja.job_offer).to eq(offer)
    end
  end

  describe 'valid?' do
    it 'should be valid when email is aMail@gmail.com' do
      email = 'aMail@gmail.com'
      ja = described_class.create_for(email, JobOffer.new)
      expect(ja).to be_valid
    end

    it 'should not be valid when the email is empty' do
      ja = described_class.create_for('', JobOffer.new)
      expect(ja).not_to be_valid
    end

    it 'should not be valid when the email has a invalid format' do
      email =  'aBadMailArrobaGmail.com'
      ja = described_class.create_for(email, JobOffer.new)
      expect(ja).not_to be_valid
    end
  end

  describe 'process' do
    it 'should deliver contact info notification' do
      ja = described_class.create_for('applicant@test.com', JobOffer.new)
      expect(JobVacancy::App).to receive(:deliver).with(:notification, :contact_info_email, ja)
      ja.process
    end
  end
end
