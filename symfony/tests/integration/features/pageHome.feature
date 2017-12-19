Feature: Home page
  In order for an agent buy a trip and find information about the company
  As an agent
  I need to know that the home page is correctly working

  Scenario: The agent can successfully access the homepage
    Given I am on "/"
    Then the response status code should be 200