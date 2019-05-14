Given('I am seeing {string} in My Offers') do |title|
  visit '/job_offers/my'
  page.should have_content(title)
end

When('I record It as satisfied') do
  click_button('Satisfied offer')
end

Then('I should not see {string} in Job Offers') do |title|
  visit '/job_offers/latest'
  page.should_not have_content(title)
end

Given('I activate it') do
  click_button('Activate')
end
