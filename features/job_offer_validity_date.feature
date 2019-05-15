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

  Scenario: Search an expired offer
    Given "Pascal developer" offer expired yesterday
    When I search "Pascal developer" offer today in the list of offers
    Then "Pascal developer" should not be listed

  Scenario: Search a a non expired offer 
    Given "Pascal developer" offer expires tomorrow
    When I search "Pascal developer" offer today in the list of offers
    Then "Pascal developer" should be in the list of offers

  Scenario: Activate an expired offer
    Given "Pascal developer" offer expired yesterday
    When I visit my offers
    Then I should see  "Expired"

  # @wip
  # Scenario: Applying to an expired offer
  #   Given "Pascal developer" offer expires in one minute
  #   When I try to apply to the offer that will expire
  #   And I wait two minutes
  #   And I apply to the offer
  #   Then I should see  "Offer expired while you were applying"
