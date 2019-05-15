Feature: Job Offers Experience
  In order to get employees with experience
  As a job offerer
  I want to specify the years of experience in the offer

  Background:
    Given I am logged in as job offerer

  Scenario: Years of experience specified
    Given I access the new offer page
    And I fill the title with "Java dev"
    And I fill the experience with 1
    When I confirm the new offer
    Then my offer is created successfully

  Scenario: Years of experience field is optional
    Given I access the new offer page
    And I fill the title with "Java dev"
    And I don't fill the experience field
    When I confirm the new offer
    Then my offer is created successfully

  @wip
  Scenario: Experience over maximum allowed amount (20)
    Given I access the new offer page
    And I fill the title with "Java dev"
    And I fill the experience with 21
    When I confirm the new offer
    Then the experience amount validation fails
    And my offer is not created


