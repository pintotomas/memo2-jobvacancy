Given('{string} offer expired yesterday') do |offer_title|
  visit '/job_offers/new'
  fill_in('job_offer[title]', with: offer_title)
  my_date_time = DateTime.now.prev_day
  date =  my_date_time.strftime('%Y-%m-%d')
  hour =  my_date_time.strftime('%H:%M')
  fill_in('job_offer[validity_date]', with: date)
  fill_in('job_offer[validity_time]', with: hour)
  click_button('Create')
  visit '/job_offers/my'
end

When('I search {string} offer today in the list of offers') do |_string|
  visit '/job_offers/latest'
end

When('I visit my offers') do
  visit '/job_offers/my'
end

Then('{string} should not be listed') do |title|
  page.should_not have_content(title)
end

Given('{string} offer expires tomorrow') do |offer_title|
  visit '/job_offers/new'
  fill_in('job_offer[title]', with: offer_title)
  my_date_time = DateTime.now.next_day
  date =  my_date_time.strftime('%Y-%m-%d')
  hour =  my_date_time.strftime('%H:%M')
  fill_in('job_offer[validity_date]', with: date)
  fill_in('job_offer[validity_time]', with: hour)
  click_button('Create')
  visit '/job_offers/my'
  click_button('Activate')
end

Then('{string} should be in the list of offers') do |title|
  page.should have_content(title)
end

Then('I should see  {string}') do |string|
  page.should have_content(string)
end

Given('{string} offer expires in one minute') do |offer_title|
  visit '/job_offers/new'
  fill_in('job_offer[title]', with: offer_title)
  my_date_time = DateTime.now
  my_date_time += Rational(2, 1440) # Expires in two minutes
  date =  my_date_time.strftime('%Y-%m-%d')
  hour =  my_date_time.strftime('%H:%M')
  fill_in('job_offer[validity_date]', with: date)
  fill_in('job_offer[validity_time]', with: hour)
  click_button('Create')
  visit '/job_offers/my'
  click_button('Activate')
end
When('I try to apply to the offer that will expire') do
  visit '/job_offers/latest'
  click_link 'Apply'
end
When('I wait two minutes') do
  sleep(130)
end
When('I apply to the offer') do
  fill_in('job_application[applicant_email]', with: 'applicant@test.com')
  fill_in('job_application[bio]', with: 'asd')
  click_button('Apply')
end
