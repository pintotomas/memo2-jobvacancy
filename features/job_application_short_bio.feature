 Feature: Job Application short bio
  Background:
    Given ‘python dev’ job offer is created
@wip
  Scenario: Short bio field
    Given I am applying to ‘python dev’ job offer 
    Then I should be able to complete a short bio.
@wip
  Scenario: Short bio is mandatory
    Given I am applying to ‘python dev’ job offer 
    And set the email to ‘fake@test.com’
    And I leave the short bio empty
    When I confirm my application
    Then I should not be able to apply.
@wip
  Scenario: Short bio is less than 500 characters
    Given I am applying to ‘python dev’ job offer 
    And set the email to ‘fake@test.com’
    And I fill the short bio field with ‘test’
    When I confirm my application
    Then I should apply successfully.
@wip
  Scenario: Short bio is more than 500 characters
    Given I am applying to ‘python dev’ job offer 
    And set the email to ‘fake@test.com’
    And I fill the short bio field with a text longer than 500 characters
    When I confirm my application
    Then I should not be able to apply.

