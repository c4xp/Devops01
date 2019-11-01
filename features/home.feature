Feature: Homepage is accessible
  In order access the site
  As a visitor
  I can go to the homepage and see something

  Scenario: Homepage works
    When I go to the homepage
    Then I should see "demox"


  @javascript
  Scenario: Searching for "behat"
     Given I go to the homepage
     When I fill in "searchify" with "behatish"
     And I press "submit"
     Then I should see "behatish"
