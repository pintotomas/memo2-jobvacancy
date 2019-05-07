Feature: Job Application
  In order to get a job
  As a candidate
  I want to apply to an offer

  Background:
  	Given only a "Web Programmer" offer exists in the offers list

  Scenario: Apply to job offer
    Given I access the offers list page
    When I apply
    Then I should receive a mail with offerer info

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