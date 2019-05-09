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
  click_button('Activate')
end

When('I search {string} offer today in the list of offers') do |_string|
  visit '/job_offers/latest'
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
