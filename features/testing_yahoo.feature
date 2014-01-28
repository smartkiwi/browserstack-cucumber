@selenium
Feature: trying to figure out why Yahoo changed logo


  Scenario: let's ask yahoo do they know
    Given I am on the yahoo page
    When I do search for phrase "why yahoo changed the logo"
    Then I should see more then "1" result

