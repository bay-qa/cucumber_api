Feature: Test scenarios for user API

  Scenario: Say hi
    Given a "GET" request is made to "/hi"
    Then the api call should succeed

  Scenario: Create new user with valid student details
    Given a "POST" request is made to "/users"
    When these parameters are supplied in URL:
      | name     | Andrei Antipin   |
      | email    | andrei@gmail.com |
      | password | secret           |
    Then the api call should succeed

