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

When('I record It as dissatisfied') do
  click_button('Unsatisfied offer')
end

Then('I should see {string} in Job Offers') do |title|
  visit '/job_offers/latest'
  page.should have_content(title)
end

Given('I am postulating to it') do
  visit '/job_offers/latest'
  click_link 'Apply'
  fill_in('job_application[bio]', with: 'bio')
  fill_in('job_application[applicant_email]', with: 'fake@test.com')
end

Given('It gets satisfied before I apply') do
  offers = JobOfferRepository.new.all_unsatisfied
  offers.each do |offer|
    offer.satisfy
    JobOfferRepository.new.save(offer)
  end
end

Given('I apply to this offer') do
  click_button('Apply')
end

Then('I shouldnt be able to apply') do
  page.should have_content('Offer was satisfied before you completed your application')
end
