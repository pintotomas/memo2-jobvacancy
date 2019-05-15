Given('I am in the registration view') do
  visit '/register'
end

Given('my name is {string}') do |name|
  fill_in('user[name]', with: name)
end

Given('my email is {string}') do |mail|
  fill_in('user[email]', with: mail)
end

Given('I fill with {string} the password fields') do |password|
  fill_in('user[password]', with: password)
end

When('I confirm the registration') do
  click_button('Create')
end

Given('I fill with {string} the password confirmation fields') do |password_confirmation|
  fill_in('user[password_confirmation]', with: password_confirmation)
end

Then('My user should have created') do
  page.should have_content('User created')
end

Then('My user should have been created') do
  page.should have_content('User created')
end

Then('My user should not have been created') do
  page.should_not have_content('User created')
end
