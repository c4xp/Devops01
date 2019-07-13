Feature: Homepage is accessible
  In order access the site
  As a visitor
  I can go to the homepage and see something

  Scenario: Homepage works
    When I go to the homepage
    Then I should see "demox"

  Scenario: Cineva care scrie si nu stie sa scrie
    Given I browse the site
    And I am tired
    When that I am logged In
    Then I should see "logout"