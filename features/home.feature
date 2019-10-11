Feature: Homepage is accessible
  In order access the site
  As a visitor
  I can go to the homepage and see something

  Scenario: Homepage works
    When I go to the homepage
    Then I should see "demox"
