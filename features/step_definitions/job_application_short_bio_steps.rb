Given(/^I should be able to complete a short bio$/) do
  click_link 'Apply'
  page.should have_content('Bio')
end

Given(/^I leave the short bio empty$/) do
  fill_in('job_application[bio]', with: '')
end

Given(/^I fill the short bio with "(.*?)"$/) do |short_bio|
  fill_in('job_application[bio]', with: short_bio)
end

Given(/^I fill the short bio field with a text longer than 500 characters$/) do
  bio = ''
  (1..501).each do |_i|
    bio += 'a'
  end
  fill_in('job_application[bio]', with: bio)
end
