Given(/^offer with title "(.*?)", location "(.*?)", description "(.*?)" exists on the offers list$/) do |job_title, location, description|
  @job_offer = JobOffer.new
  @job_offer.owner = UserRepository.new.first
  @job_offer.title = job_title
  @job_offer.location = location
  @job_offer.description = description
  @job_offer.is_active = true
  @job_offer.updated_on = DateTime.now
  @job_offer_repository ||= JobOfferRepository.new
  @job_offer_repository.save @job_offer
end

Given(/^I access the active offers list page$/) do
  visit '/job_offers/latest'
end

When(/^I search for "(.*?)"$/) do |term|
  fill_in('q', with: term)
  click_button('search')
end

Then(/^I see offer with title "(.*?)"$/) do |tittle|
  page.should have_content(tittle)
end

Then(/^I don't see offer with title "(.*?)"$/) do |tittle|
  page.should_not have_content(tittle)
end
