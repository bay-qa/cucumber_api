Feature: Positive scenarios for /posts API

  Scenario: Add post as a logged in user
    Given a "POST" request is made to "/login"
    When these parameters are supplied in URL:
      | email    | andrei@hotmail.com |
      | password | secret             |
    Then the api call should succeed
    Given a "POST" request is made to "/posts"
    When these parameters are supplied in body:
      | {"content": "test content"} |
    Then the api call should succeed
    And value of "id" is saved in a global variable
    And these response keys should have value:
      | content | test content |

  Scenario: Get all post for current user
    Given a "GET" request is made to "/posts/me"
    Then the api call should succeed

  Scenario: Update post with valid id
    Given a "PUT" request is made to "/posts/<id>"
    When these parameters are supplied in body:
      | {"content": "updated content"} |
    Then the api call should succeed
    And these response keys should have value:
      | content | updated content |

  Scenario: Delete post with valid id
    Given a "DELETE" request is made to "/posts/<id>"
    Then the api call should succeed
    And these response keys should have value:
      | Success | Post deleted |