Feature: search offers


  Background:
    Given offer with title "Java dev", location "Capital", description "very nice job indeed" exists on the offers list
    And offer with title "C# dev", location "Disney", description "capital javaset nice test job" exists on the 
    And offer with title "Mordor dev", location "Mordor java", description "frodo pls abstain" exists on the 
    And I access the ofers list page

  @wip
  Scenario: search is case insensitive
    When I search for "FRODO"
    Then I only see offer with title "Mordor dev"

  @wip
  Scenario: search looks for match in title, location and description fields
    When I search for "java"
    Then I see offer with title "Java dev"
    And I see offer with title "C# dev"
    And I see offer with title "Mordor dev"

  @wip
  Scenario: search term must match completely
    When I search for "nice job"
    Then I only see offer with title "Java dev"
