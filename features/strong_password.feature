Feature: Strong passwords

  In order to have safer accounts
  As Job Vacancy owner
  I want the user’s passwords to be at least 8 characters long, an upper case letter, a lower case letter and one number or symbol

  Background:
    Given I am in the registration view
    And my name is "Bob"
    And my email is "bob@test.com"
    
  Scenario: Valid password with number
    Given I fill with "Valid123" the password fields
    And I fill with "Valid123" the password confirmation fields
    When I confirm the registration
    Then I should see the message "User created"

 @wip
  Scenario: Valid password with symbol
    Given I fill with "Falafel!" the password fields
    And I fill with "Falafel!" the password confirmation fields
    When I confirm the registration
    Then I should see the message "User created"

