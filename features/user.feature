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
    And these response keys should have value:
      | name  | Andrei Antipin   |
      | email | andrei@gmail.com |

  Scenario Outline: Create new user with invalid student details
    Given a "POST" request is made to "/users"
    When these parameters are supplied in URL:
      | name     | <name>     |
      | email    | <email>    |
      | password | <password> |
    Then the api call should fail
    And these response keys should have value:
      | Error | <error> |
    Examples:
      | name                                                | email            | password | error                                                                                |
      |                                                     |                  |          | Name can't be blank, Email can't be blank, Email is invalid, Password can't be blank |
      |                                                     | test@gmail.com   | secret   | Name can't be blank                                                                  |
      | Andrei Antipin                                      |                  | secret   | Email can't be blank, Email is invalid                                               |
      | Andrei Antipin                                      | test@gmail.com   |          | Password can't be blank                                                              |
      | name is too long name is too long name is too  long | test@gmail.com   | secret   | Name is too long (maximum is 50 characters)                                          |
      | Andrei Antipin                                      | testgmail.com    | secret   | Email is invalid                                                                     |
      | Andrei Antipin                                      | andrei@gmail.com | secret   | Email has already been taken                                                         |

