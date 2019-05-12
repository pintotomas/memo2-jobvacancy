Feature: record an offer as satisfied or dissatisfied

Background:
   Given I have created "Ruby dev" job offer only
@wip
Scenario: Record my offer as satisfied
      Given I am seeing "Ruby dev" in My Offers
   When I record my offer as satisfied
      Then  I should not see "Ruby dev" in Job Offers
