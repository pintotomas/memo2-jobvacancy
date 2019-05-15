Given('I fill the experience with {int}') do |experience|
  fill_in('job_offer[experience]', with: experience)
  @experience = experience
end

When('I confirm the new offer') do
  click_button('Create')
end

Then('my offer is created successfully') do
  visit '/job_offers/my'
  page.should have_content(@experience)
end

Given("I don't fill the experience field") do
  fill_in('job_offer[experience]', with: nil)
  @experience = 'Not specified'
end

Then('the experience amount validation fails') do
  page.should have_content('Experience must be')
end

Then('my offer is not created') do
  visit '/job_offers/my'
  page.should_not have_content(@experience)
end

Given('I have {string} offer with {int} experience required offer in My Offers') do |title, experience|
  page.should have_content('offerer@test.com')
  @job_offer = JobOffer.new
  @job_offer.owner = UserRepository.new.first
  @job_offer.title = title
  @job_offer.location = 'a nice location'
  @job_offer.description = 'a nice job'
  @job_offer.experience = experience
  @jexperience = experience
  @job_offer.is_active = false
  JobOfferRepository.new.save @job_offer
  visit '/job_offers/my'
end

Given('I set experience to {int}') do |experience|
  fill_in('job_offer[experience]', with: experience)
end

Then('the offer should be updated') do
  page.should have_content('Offer updated')
end

Then('the offer’s experience should be {int}') do |_int|
  visit '/job_offers/my'
  page.should have_content(@experience)
end
