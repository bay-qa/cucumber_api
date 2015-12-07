Feature: Negative scenarios for /users API

  Scenario Outline: Create new user with invalid user details
    Given a "POST" request is made to "/users"
    When these parameters are supplied in URL:
      | name     | <name>     |
      | email    | <email>    |
      | password | <password> |
    Then the api call should fail
    And these response keys should have value:
      | Error | <error> |
    Examples:
      | name           | email              | password | error                                           |
      |                | andrei@nomail.com  | secret   | Name can't be blank                             |
      | Andrei Antipin |                    | secret   | Email can't be blank, Email is invalid          |
      | Andrei Antipin | andrei@nomail.com  |          | Password can't be blank                         |
      | Andrei Antipin | andrei@hotmail.com | secret   | Email has already been taken                    |
      | Andrei Antipin | andrei@nomail.com  | sec      | Password is too short (minimum is 6 characters) |

    # Email address validation scenarios
    Examples:
      | name           | email                        | password | error            | Comment                                       |
      | Andrei Antipin | plainaddress                 | secret   | Email is invalid | Missing @ sign and domain                     |
      | Andrei Antipin | #@%^%#$@#$@#.com             | secret   | Email is invalid | Garbage                                       |
      | Andrei Antipin | @domain.com                  | secret   | Email is invalid | Missing username                              |
      | Andrei Antipin | Joe Smith <email@domain.com> | secret   | Email is invalid | Encoded html within email is invalid          |
      | Andrei Antipin | email.domain.com             | secret   | Email is invalid | Missing @                                     |
      | Andrei Antipin | email@domain@domain.com      | secret   | Email is invalid | Two @ sign                                    |
      | Andrei Antipin | email@domain.com (Joe Smith) | secret   | Email is invalid | Text followed email is not allowed            |
      | Andrei Antipin | email@domain                 | secret   | Email is invalid | Missing top level domain (.com/.net/.org/etc) |
      | Andrei Antipin | email@111.222.333.44444      | secret   | Email is invalid | Invalid IP format                             |
      | Andrei Antipin | email@domain..com            | secret   | Email is invalid | Multiple dot in the domain portion is invalid |

  Scenario: Login with invalid user details
    Given a "POST" request is made to "/login"
    When these parameters are supplied in URL:
      | email    | test@gmail.com |
      | password | secret         |
    Then the api call should fail
    And these response keys should have value:
      | Error | Invalid email/password combination |

  Scenario: Logout user
    Given a "DELETE" request is made to "/logout"
    Then the api call should succeed
    And these response keys should have value:
      | Success | Logged out |

  Scenario: Get user details without valid authentication (user is not logged in)
    Given a "GET" request is made to "/users/100"
    Then the api call should fail
    And these response keys should have value:
      | Error | Unauthenticated |

  Scenario: Delete user without valid authentication (user is not logged in)
    Given a "DELETE" request is made to "/users/100"
    Then the api call should fail
    And these response keys should have value:
      | Error | Unauthenticated |

  Scenario: Get user without valid authorization (user is logged in, but trying to access another account)
    Given a "POST" request is made to "/login"
    When these parameters are supplied in URL:
      | email    | andrei@hotmail.com |
      | password | secret             |
    Then the api call should succeed
    Given a "GET" request is made to "/users/100"
    Then the api call should fail
    And these response keys should have value:
      | Error | Unauthorized |

  Scenario: Delete user without valid authorization (user is logged in, but trying to delete another account)
    Given a "POST" request is made to "/login"
    When these parameters are supplied in URL:
      | email    | andrei@hotmail.com |
      | password | secret             |
    Then the api call should succeed
    Given a "DELETE" request is made to "/users/100"
    Then the api call should fail
    And these response keys should have value:
      | Error | Unauthorized |









