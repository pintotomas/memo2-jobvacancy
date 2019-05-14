Feature: record an offer as satisfied or dissatisfied

Background:
   Given I have created "Ruby dev" job offer only

Scenario: Record my offer as satisfied
      Given I am seeing "Ruby dev" in My Offers
      And I activate it
   	  When I record It as satisfied
      Then  I should not see "Ruby dev" in Job Offers
