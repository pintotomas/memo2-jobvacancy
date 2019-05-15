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
