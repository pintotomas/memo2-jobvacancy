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
