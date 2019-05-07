 Feature: Job Application count
  Background:
    Given I have created "python dev" job offer only

  Scenario: Applicants quantity field
    Given I am seeing the job offers i created
    Then I can know how many applicants my offer has

  Scenario: Applicants quantity after creation

    Given I have never activated "python dev" job offer 
    When I see my offers
    Then no one could have applied to "python dev" offer

  Scenario: Applicants quantity after someone applies
    Given I have activated "python dev" job offer
    When only one person has applied to "python dev" job offer
    And I see my offers
    Then only one postulant could have applied to "python dev" offer

