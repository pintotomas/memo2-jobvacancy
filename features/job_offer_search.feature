Feature: search offers


  Background:
    Given offer with title "Java dev", location "Capital", description "very nice job indeed" exists on the offers list
    And offer with title "C# dev", location "Disney", description "capital javaset nice test job" exists on the offers list
    And offer with title "Mordor dev", location "Mordor java", description "frodo pls abstain" exists on the offers list
    And I access the active offers list page

  Scenario: search is case insensitive
    When I search for "FRODO"
    Then I see offer with title "Mordor dev"
    And I don't see offer with title "C# dev"
    And I don't see offer with title "Java dev"

  Scenario: search looks for match in title, location and description fields
    When I search for "java"
    Then I see offer with title "Java dev"
    And I see offer with title "C# dev"
    And I see offer with title "Mordor dev"


  Scenario: search term must match completely
    When I search for "nice job"
    Then I see offer with title "Java dev"
    And I don't see offer with title "C# dev"
    And I don't see offer with title "Mordor dev"