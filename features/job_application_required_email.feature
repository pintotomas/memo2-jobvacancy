Feature: Job Application
  In order to get a job
  As a candidate
  I want to apply to an offer

  Background:
    Given "java programmer" offer exists in the offer list

  Scenario: Apply  to job offer
    Given I access the offers list page
    And I am applying to "java programmer" offer
    And I entered a short bio
    And I set my email to "aMail@gmail.com"
    When I confirm my application
    Then I should apply successfully.

  Scenario: Apply  to job offer without email
    Given I access the offers list page
    And I am applying to "java programmer" offer
    And I entered a short bio
    When I confirm my application
    Then I should not be able to apply

  Scenario: Apply  to job offer with invalid email
    Given I access the offers list page
    And I am applying to "java programmer" offer
    And I entered a short bio
    And I set my email to "aBadMailArrobaGmail.com"
    When I confirm my application
    Then I should not be able to apply


