require 'integration_spec_helper'
require 'byebug'

describe JobApplicationRepository do
  let(:job_offers_repo) { JobOfferRepository.new }
  let(:job_applications_repo) { described_class.new }

  describe 'Find correct offers' do
    let!(:offer_one) do
      offer_one = JobOffer.new(title: 'a title',
                               updated_on: Date.today,
                               is_active: true)
      job_offers_repo.save(offer_one)
      offer_one
    end
    let!(:offer_two) do
      offer_two = JobOffer.new(title: 'a title',
                               updated_on: Date.today,
                               is_active: true)
      job_offers_repo.save(offer_two)
      offer_two
    end

    let!(:application_two) do
      application_two = JobApplication
                        .new(email: 'f2@a.com', job_offer_id: offer_two.id, created_on: Date.today,
                             updated_on: Date.today, bio: 'short bio')
      job_applications_repo.save(application_two)
      application_two
    end
    let!(:application_one) do
      application_one = JobApplication
                        .new(email: 'f1@a.com', job_offer_id: offer_two.id, created_on: Date.today,
                             updated_on: Date.today, bio: 'short bio')
      job_applications_repo.save(application_one)
      application_one
    end

    it 'job applications repo should find the postulated offer only' do
      application = JobApplication
                    .new(email: 'f@a.com', job_offer_id: offer_one.id, created_on: Date.today,
                         updated_on: Date.today, bio: 'short bio')
      job_applications_repo.save(application)
      expect(job_applications_repo.find_by_offer(offer_one).length).to eq 1
      expect(job_applications_repo.find_by_offer(offer_one)[0].job_offer_id).to eq offer_one.id
    end

    it 'find two applications to a job offer' do
      expect(job_applications_repo.find_by_offer(offer_two).length).to eq 2
      expect(job_applications_repo.find_by_offer(offer_two)[0].job_offer_id).to eq offer_two.id
      expect(job_applications_repo.find_by_offer(offer_two)[1].job_offer_id).to eq offer_two.id
    end
  end
end
