 Feature: Job Application count
  Background:
    Given I have created "python dev" job offer only
    
  Scenario: Applicants quantity after creation

    Given I have never activated "python dev" job offer 
    When I see my offers
    Then no one could have applied to "python dev" offer