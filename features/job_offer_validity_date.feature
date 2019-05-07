Feature: Job Validity Date
  In order to stop receiving job applications
  As an offerer
  I want to define a validity date for my offers
  @wip
  Scenario: Create new offer with a validity date
    Given I access the new offer page
    When I set the title to "Pascal developer" 
    And set the validity date to “28/04/2019”
    And set location to "India" 
    And set description to "another description"
    And confirm the new offer
    Then the offer is created successfully

