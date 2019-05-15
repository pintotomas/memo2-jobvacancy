Given(/^I have created "(.*?)" job offer only$/) do |job_title|
  visit '/login'
  fill_in('user[email]', with: 'offerer@test.com')
  fill_in('user[password]', with: 'Passw0rd')
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

Then('no one could have applied to {string} offer') do |_offer_title|
  visit '/job_offers/my'
  page.should have_content('0')
end

Given('I have activated {string} job offer') do |offer_title|
  offer = JobOfferRepository.new.find_by_title(offer_title)[0]
  offer.is_active = true
  JobOfferRepository.new.save offer
end

When('only one person has applied to {string} job offer') do |offer_title|
  offer = JobOfferRepository.new.find_by_title(offer_title)[0]
  job_application = JobApplication.new(job_offer_id: offer.id, applicant_email: 'asd@gmail.com')
  JobApplicationRepository.new.save(job_application)
  expect(job_application.job_offer_id).to eq offer.id
end

Then('only one postulant could have applied to {string} offer') do |_offer_title|
  visit '/job_offers/my'
  page.should have_content('1')
end

Given('I am seeing the job offers i created') do
  visit '/job_offers/my'
end

Then('I can know how many applicants my offer has') do
  page.should have_content('Postulations')
end
