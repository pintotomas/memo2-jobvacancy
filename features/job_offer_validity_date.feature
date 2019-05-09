Feature: Job Validity Date
  In order to stop receiving job applications
  As an offerer
  I want to define a validity date for my offers


  Background:
    Given I am logged in as job offerer

  Scenario: Create new offer with a validity date
    Given I access the new offer page
    When I set the title to "Pascal developers2"
    And set the validity date to "28/04/2019 10:30 PM"
    And set location to "India"
    And set description to "another description"
    And confirm the new offer
    Then I should see "Offer created"
    And I should see "Pascal developers2" in My Offers

  Scenario: Create new offer with a validity date with invalid format
    Given I access the new offer page
    When I set the title to "Pascal developer"
    And set the validity date to "a28/y04/2019 10:30 PM"
    And set location to "India"
    And set description to "another description"
    And confirm the new offer
    And I should not see "Pascal developer" in My Offers

  @wip
  Scenario: Search a expired offer
    Given “Pascal developer” offer expires in “28/04/2019”



 
