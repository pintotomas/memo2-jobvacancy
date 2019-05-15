Feature: record an offer as satisfied or dissatisfied

Background:
   Given I have created "Ruby dev" job offer only

Scenario: Record my offer as satisfied
      Given I am seeing "Ruby dev" in My Offers
      And I activate it
   	  When I record It as satisfied
      Then  I should not see "Ruby dev" in Job Offers

Scenario: Record my offer as dissatisfied
      Given I am seeing "Ruby dev" in My Offers 
      And I activate it   
      When I record It as satisfied
      And I record It as dissatisfied
      Then  I should see "Ruby dev" in Job Offers

Scenario: Apply after offer is satisfied
      Given I am seeing "Ruby dev" in My Offers 
      And I activate it   
      And I am postulating to it
      And It gets satisfied before I apply
      And I apply to this offer
      Then  I shouldnt be able to apply
