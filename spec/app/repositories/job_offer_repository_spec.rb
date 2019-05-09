require 'integration_spec_helper'
require 'byebug'

describe JobOfferRepository do
  let(:repository) { described_class.new }

  let(:owner) do
    user = User.new(name: 'Joe', email: 'joe@doe.com', crypted_password: 'secure_pwd')
    UserRepository.new.save(user)
    user
  end

  describe 'find by id' do
    let!(:today_offer) do
      today_offer = JobOffer.new(title: 'a title',
                                 updated_on: Date.today,
                                 is_active: true,
                                 user_id: owner.id)
      repository.save(today_offer)
      today_offer
    end

    it 'should find correct offer' do
      offer = repository.find_by_id(today_offer.id)[0]
      expect(offer.title).to eq today_offer.title
      expect(offer.user_id).to eq today_offer.user_id
      expect(offer.updated_on).to eq today_offer.updated_on
    end
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

    let!(:today_unexpired_offer) do
      today = Date.today
      tomorrow_day = today.next_day.day
      tomorrow_month = today.next_day.month
      tomorrow_year = today.next_day.year
      day = String(tomorrow_year) + '-' + String(tomorrow_month) + '-' + String(tomorrow_day)
      today_unexpired_offer = JobOffer.new(title: 'a title',
                                           updated_on: today,
                                           is_active: true,
                                           user_id: owner.id,
                                           validity_date: day,
                                           validity_time: '08:00')
      repository.save(today_unexpired_offer)
      today_unexpired_offer
    end

    let!(:today_expired_offer) do
      yesterday = Date.today.prev_day
      exp_day = String(yesterday.year) + '-' + String(yesterday.month) + '-' + String(yesterday.day)
      today_expired_offer = JobOffer.new(title: 'a expired offer',
                                         updated_on: yesterday,
                                         is_active: true,
                                         user_id: owner.id,
                                         validity_date: exp_day,
                                         validity_time: '23:59')
      repository.save(today_expired_offer)
      today_expired_offer
    end

    it 'should not deactivate offers created today, expire date specified' do
      repository.deactivate_old_offers

      not_updated_offer = repository.find(today_unexpired_offer.id)
      expect(not_updated_offer.is_active).to eq true
    end
    it 'should deactivate offer that expired yesterday' do
      repository.deactivate_old_offers

      not_updated_offer = repository.find(today_expired_offer.id)
      expect(not_updated_offer.is_active).to eq false
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
