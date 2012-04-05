Feature:
  In order to have simple github-like messaging functionality on my site
  As a user
  I want to send, receive and manage messages easily 

  Scenario: Listing Carrier main page when there are no messages created
    Given I am logged in as user 
    When I am on Carrier's main page
    Then I should see "No messages yet"

  Scenario: Listing Carrier inbox page when there is a message I sent 
    Given There is user with username "stanislaw"
    And There is second user with username "miloviza"
    And There is a message with content "Hello, Miloviza!"
    And I am logged in as user 
    When I am on Carrier's 'inbox' page
    Then I should see "No messages yet"

  Scenario: Listing Carrier 'sent' page when there is a message I sent 
    Given There is user with username "stanislaw"
    And There is second user with username "miloviza"
    And There is a message with content "Hello, Miloviza!"
    And I am logged in as user 
    When I am on Carrier's 'sent' page
    Then I should see "Hello, Miloviza!"


  Scenario: Creating a message
    Given There is user with username "stanislaw"
    And There is second user with username "miloviza"
    And I am logged in as user 
    And I go to new message path
    And I select "miloviza" from "Recipients"
    And I fill in "Subject" with "Subject for test message"
    And I fill in "Message" with "Content for test message"
    And I press "Send"
    Then I should see "Message successfully created"
    Then I should see "Subject for test message"
    Then I should see "Content for test message"

  @javascript
  Scenario: Archiving a message
    Given There is user with username "stanislaw"
    And I am logged in as user

    And There is second user with username "miloviza" 
    And There is a message with content "Hello, Miloviza!"
    And I go to this message page
    When I click "Archive!"
    Then I should see "Thread archived"

  @javascript
  Scenario: Un-archiving a message
    Given There is user with username "stanislaw"
    And I am logged in as user

    And There is second user with username "miloviza" 
    And There is a message with content "Hello, Miloviza!"
    And I go to this message page
    And I click "Archive!"
    Then I should see "Unarchive?"

    When I click "Unarchive?"
    Then I should see "Archive!"
    
  @javascript
  Scenario: Answering a message
    Given There is user with username "stanislaw"
    And I am logged in as user

    And There is second user with username "miloviza" 
    And There is a message with content "Hello, Miloviza!"
    And I go to this message page

    And I click "Reply into thread"
    And I fill in "Message" with "This is the answer to the message"
    And I press "Reply"
    Then I should see "This is the answer to the message"
    Then I should not see "Reply" within "#reply_form"
