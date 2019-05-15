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
