When(/^I browse the default page$/) do
  visit '/'
end

Given(/^I am logged in as job offerer$/) do
  visit '/login'
  fill_in('user[email]', with: 'offerer@test.com')
  fill_in('user[password]', with: 'Aa123456')
  click_button('Login')
  page.should have_content('offerer@test.com')
end

Given(/^I access the new offer page$/) do
  visit '/job_offers/new'
  page.should have_content('Title')
end

When(/^I fill the title with "(.*?)"$/) do |offer_title|
  fill_in('job_offer[title]', with: offer_title)
end

When(/^confirm the new offer$/) do
  click_button('Create')
end

Then(/^I should see "(.*?)" in My Offers$/) do |content|
  visit '/job_offers/my'
  page.should have_content(content)
end

Then(/^I should not see "(.*?)" in My Offers$/) do |content|
  visit '/job_offers/my'
  page.should_not have_content(content)
end

Given(/^I have "(.*?)" offer in My Offers$/) do |offer_title|
  JobOfferRepository.new.delete_all

  visit '/job_offers/new'
  fill_in('job_offer[title]', with: offer_title)
  click_button('Create')
end

Given(/^I edit it$/) do
  click_link('Edit')
end

And(/^I delete it$/) do
  click_button('Delete')
end

Given(/^I set title to "(.*?)"$/) do |new_title|
  fill_in('job_offer[title]', with: new_title)
end

Given(/^I save the modification$/) do
  click_button('Save')
end

When('I set the title to {string}') do |offer_title|
  fill_in('job_offer[title]', with: offer_title)
end

When('set the validity date to {string}') do |datetime|
  begin
    my_date_time = DateTime.strptime(datetime, '%d/%m/%Y %I:%M %p')
    date =  my_date_time.strftime('%Y-%m-%d')
    hour =  my_date_time.strftime('%H:%M')
  rescue ArgumentError
    date = '-1'
    hour = '-1'
  end
  fill_in('job_offer[validity_date]', with: date)
  fill_in('job_offer[validity_time]', with: hour)
end

When('set location to {string}') do |location|
  fill_in('job_offer[location]', with: location)
end

When('set description to {string}') do |description|
  fill_in('job_offer[description]', with: description)
end
