 Feature: Save the information of a job application
  Background:
    Given only a "javascript developer" offer exists in the offers list

  Scenario: Save the information 
    Given I access the offers list page
    And I am applying to "javascript developer" offer
    And I set my email to "fakemail@gmail.com"
    And I fill the short bio with "short bio"
    When I confirm my application
    Then information on the job application should be saved.


