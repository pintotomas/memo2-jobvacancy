Given('{string} offer exists in the offer list') do |job_title|
  @job_offer = JobOffer.new
  @job_offer.owner = UserRepository.new.first
  @job_offer.title = job_title
  @job_offer.location = 'a nice job'
  @job_offer.description = 'a nice job'
  @job_offer.is_active = true

  JobOfferRepository.new.save @job_offer
end

Given('I am applying to {string} offer') do |_email|
  click_link 'Apply'
end

Given('I entered a short bio') do
  fill_in('job_application[bio]', with: 'bio')
end

Given('I set my email to {string}') do |email|
  @applicant_email = email
  fill_in('job_application[applicant_email]', with: email)
end

When('I confirm my application') do
  click_button('Apply')
end

Then('I should apply successfully.') do
  mail_store = "#{Padrino.root}/tmp/emails"
  file = File.open("#{mail_store}/" + @applicant_email, 'r')
  content = file.read
  content.include?(@job_offer.title).should be true
  content.include?(@job_offer.location).should be true
  content.include?(@job_offer.description).should be true
  content.include?(@job_offer.owner.email).should be true
  content.include?(@job_offer.owner.name).should be true
end

Then('I should not be able to apply') do
  page.should_not have_content('Current Job Offers')
end
