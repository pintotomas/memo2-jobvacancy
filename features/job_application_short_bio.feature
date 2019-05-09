 Feature: Job Application short bio
  Background:
    Given "java programmer" offer exists in the offer list

  Scenario: Short bio field is present
    Given I access the offers list page
    Then I should be able to complete a short bio
 
  Scenario: Short bio is mandatory
    Given I access the offers list page
    And I am applying to "java programmer" offer 
    And I set my email to "fakemail@gmail.com"
    And I leave the short bio empty
    When I confirm my application
    Then I should not be able to apply

  Scenario: Short bio is less than 500 characters
    Given I access the offers list page
    And I am applying to "java programmer" offer 
    And I set my email to "fakemail@gmail.com"
    And I fill the short bio with "short bio"
    When I confirm my application
    Then I should apply successfully.

  Scenario: Short bio is longer than 500 characters    
    Given I access the offers list page
    And I am applying to "java programmer" offer 
    And I set my email to "fakemail@gmail.com"
    And I fill the short bio field with a text longer than 500 characters
    When I confirm my application
    Then I should not be able to apply

