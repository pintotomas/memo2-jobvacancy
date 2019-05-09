require 'integration_spec_helper'

describe JobOfferRepository do
  let(:repository) { described_class.new }

  let(:owner) do
    user = User.new(name: 'Joe', email: 'joe@doe.com', crypted_password: 'secure_pwd')
    UserRepository.new.save(user)
    user
  end

  describe 'deactive_old_offers' do
    let!(:today_offer) do
      today_offer = JobOffer.new(title: 'a title',
                                 updated_on: Date.today,
                                 is_active: true,
                                 user_id: owner.id)
      repository.save(today_offer)
      today_offer
    end

    let!(:thirty_day_offer) do
      thirty_day_offer = JobOffer.new(title: 'a title',
                                      updated_on: Date.today - 45,
                                      is_active: true,
                                      user_id: owner.id)
      repository.save(thirty_day_offer)
      thirty_day_offer
    end

    let!(:today_offer2) do
      today = Date.today
      tomorrow_day = today.next_day.day
      tomorrow_month = today.next_day.month
      tomorrow_year = today.next_day.year
      day = String(tomorrow_year) + '-' + String(tomorrow_month) + '-' + String(tomorrow_day)
      today_offer2 = JobOffer.new(title: 'a title',
                                  updated_on: today,
                                  is_active: true,
                                  user_id: owner.id,
                                  validity_date: day,
                                  validity_time: '08:00')
      repository.save(today_offer2)
      today_offer2
    end

    it 'should not deactivate offers created today, expire date specified' do
      repository.deactivate_old_offers

      not_updated_offer = repository.find(today_offer2.id)
      expect(not_updated_offer.is_active).to eq true
    end

    it 'should deactivate offers updated 45 days ago, no exp date specified' do
      repository.deactivate_old_offers

      updated_offer = repository.find(thirty_day_offer.id)
      expect(updated_offer.is_active).to eq false
    end

    it 'should not deactivate offers created today, no exp date specified' do
      repository.deactivate_old_offers

      not_updated_offer = repository.find(today_offer.id)
      expect(not_updated_offer.is_active).to eq true
    end
  end
end
