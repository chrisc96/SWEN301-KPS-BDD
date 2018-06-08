Feature: Mail Delivery Costs for KPS

  Scenario Outline: Price for mail originating from overseas (outside NZ) should be free for KPS

    To reference the specification it states that:
        'mail originating from overseas for New Zealand destinations is delivered at no cost'

    Contradiction:
        'All mail that goes through KPS originates in New Zealand'

    Not really sure about this... I am assuming that if we add mail to the KPS system from overseas to NZ then the expected
    cost should be 0, even though it says all mail should originate in NZ.

    To clarify, I'm also presuming 'no cost' is referring to zero cost for KPS not the customer.

    Therefore if we setup tests for mail with a from city/country from outside of new zealand, the expected cost should
    be 0.

    We will only use routes given to us using the default data.xml

    Given an initial map
    Given a parcel that weighs <Weight>kg
    Given a parcel that measures <Measurement> cc
    And I send the parcel from "<FromCity>" "<FromCountry>"
    And I send the parcel to "<ToCity>" "<ToCountry>"
    And I send the parcel by "<MailPriority>"
    Given a route exists for this mail
    Then the cost is $<ExpectedCost>
    Examples:
      | Weight  | Measurement    | FromCity        | FromCountry   | ToCity          | ToCountry   | MailPriority           | ExpectedCost |
      | 5       | 1000           | Singapore City  | Singapore     | Wellington      | New Zealand | international standard | 0            |
      | 5       | 1000           | Singapore City  | Singapore     | Auckland        | New Zealand | international standard | 0            |
      | 5       | 1000           | Singapore City  | Singapore     | Wellington      | New Zealand | international standard | 0            |
      | 5       | 1000           | Place           | Martin Island | Auckland        | New Zealand | international standard | 0            |
      | 5       | 1000           | Singapore City  | Singapore     | Auckland        | New Zealand | international air      | 0            |
      | 5       | 1000           | Singapore City  | Singapore     | Wellington      | New Zealand | international air      | 0            |
      | 5       | 1000           | Montreal        | Canada        | Auckland        | New Zealand | international air      | 0            |
      | 5       | 1000           | Sydney          | Australia     | Auckland        | New Zealand | international air      | 0            |


  Scenario Outline: Test all mail to an overseas country goes to the same port

    To quote the specification:
      'For the sake of simplicity, it is assumed that all mail to a country goes to the same port.'
      AND
      'internationally to an overseas sea/air port where it is then handled by a local mail service partner.'

    This means that given some country outside of NZ, we shouldn't ever have more than one City for a given overseas
    country as this would mean that all mail is not going through to the same port.

    This makes us reliant on the data.xml, but it still tests the specification, as the data.xml is used by the domain program.
    I added all the overseas countries found in the info file.

    Given an initial map
    And I want to send a parcel to the overseas country: "<Country>"
    Then I should be only able to send it to one place
    Examples:
      | Country   |
      | Australia |
      | Singapore |
      | Martin Island  |
      | Canada         |

  Scenario Outline: Test sending mail to destinations where there is no method of transport
  # KPS does not accept mail for destinations if there is no chain of transport routes to that destination (unreachable, non-existent etc)


  #
  #
  # GENERAL MAIL SENDING TESTS
  #
  #


  Scenario: Send some mail from Wellington to Place, Martin Island with a hop in Auckland
    Given an initial map
    Given a parcel that weighs 10kg
    Given a parcel that measures 2500 cc
    And I send the parcel from "Wellington" "New Zealand"
    And I send the parcel to "Place" "Martin Island"
    And I send the parcel by "international air"
    Given a route exists for this mail
    Then as part of this route I stop off in "Auckland" "New Zealand"


  Scenario: Sending air (nothing) through mail

    Not specified in specification or in program but a side thought...
    I'm assuming the domain models' output is correct that we can in-fact 'send air' and a cost of $0 is fine
    as we're not actually sending anything.

    Mainly used just to see if the 'enhanced KPS systems' will do something differently that disallow this.

    Given an initial map
    Given a parcel that weighs 0kg
    Given a parcel that measures 0 cc
    And I send the parcel from "Wellington" "New Zealand"
    And I send the parcel to "Palmerston North" "New Zealand"
    And I send the parcel by "domestic standard"
    Then the cost is $0


  Scenario: Send some mail
    Given an initial map
    Given a parcel that weighs 1kg
    Given a parcel that measures 1000 cc
    And I send the parcel from "Wellington" "New Zealand"
    And I send the parcel to "Palmerston North" "New Zealand"
    And I send the parcel by "domestic standard"
    Then the cost is $5