Given(/^I have created "(.*?)" job offer only$/) do |job_title|
  visit '/login'
  fill_in('user[email]', with: 'offerer@test.com')
  fill_in('user[password]', with: 'Passw0rd!')
  click_button('Login')
  page.should have_content('offerer@test.com')
  @job_offer = JobOffer.new
  @job_offer.owner = UserRepository.new.first
  @job_offer.title = job_title
  @job_offer.location = 'a nice location'
  @job_offer.description = 'a nice job'
  @job_offer.is_active = false

  JobOfferRepository.new.save @job_offer
end

Given('I have never activated {string} job offer') do |string|
end

When('I see my offers') do
  visit '/job_offers/my'
end

Then('no one could have applied to {string} offer') do |offer_title|
  offers = JobOfferRepository.new.find_by_title(offer_title)
  applications = JobApplicationRepository.new.find_by_offer(offers[0])
  expect(applications.length).to eq 0
end
