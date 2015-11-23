Feature: Test scenarios for user API

  Scenario: Say hi
    Given a "GET" request is made to "/hi"
    Then the api call should succeed

  @wip
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
    | name          | email               | password | error                                  |
    |               | andrei888@gmail.com | secret   | Name can't be blank                    |
    | Andrei Antipi |                     | secret   | Email can't be blank, Email is invalid |

  @wip
  Scenario: Login with invalid user details
    Given a "POST" request is made to "/login"
    When these parameters are supplied in URL:
      | email    | test@gmail.com |
      | password | secret         |
    Then the api call should fail
    And these response keys should have value:
      | Error | Invalid email/password combination |

  Scenario: Login with valid user details
    Given a "POST" request is made to "/login"
    When these parameters are supplied in URL:
      | email    | andrei@gmail.com |
      | password | secret           |
    Then the api call should succeed
    And these response keys should have value:
      | name  | Andrei Antipin   |
      | email | andrei@gmail.com |

  Scenario: Get user details with valid user id
    Given a "GET" request is made to "/users/245"
    Then the api call should succeed
    And these response keys should have value:
      | name  | Andrei Antipin   |
      | email | andrei@gmail.com |

  Scenario: Delete user details with valid user id
    Given a "DELETE" request is made to "/users/245"
    Then the api call should succeed
    And these response keys should have value:
      | Success | User deleted |

  Scenario: Get user details with invalid user id
    Given a "GET" request is made to "/users/1000"
    Then the api call should fail
    And these response keys should have value:
      | Error | Unauthenticated |










