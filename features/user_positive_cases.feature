Feature: Positive scenarios for user API

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

  Scenario: Delete user with valid user id
    Given a "DELETE" request is made to "/users/245"
    Then the api call should succeed
    And these response keys should have value:
      | Success | User deleted |











