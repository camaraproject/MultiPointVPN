Feature: CAMARA MultiPoint VPN API vwip

  Background:
    Given an environment with CAMARA MultiPoint VPN API
    And the request headers contain a valid access token with the required scope

  # createNetwork - POST /network

  @createNetwork_01_success
  Scenario: Successfully create a multipoint VPN
    Given a valid NetworkCreate request body with serviceName, isProtected, connections, guaranteeBandwidth, sla, and duration
    When I send a POST request to "/network"
    Then the response status code is 201
    And the response body includes serviceId, connections, resourceGroupId, and cloudGatewayIP

  @createNetwork_02_invalid_argument
  Scenario: Create VPN with missing required fields
    Given a NetworkCreate request body with missing connections
    When I send a POST request to "/network"
    Then the response status code is 400
    And the response property "$.code" is "INVALID_ARGUMENT"

  @createNetwork_03_unauthorized
  Scenario: Create VPN without authentication
    Given the request does not include an access token
    When I send a POST request to "/network"
    Then the response status code is 401
    And the response property "$.code" is "UNAUTHENTICATED"

  # getVpnConnection - GET /network/{serviceId}

  @getVpnConnection_01_success
  Scenario: Successfully retrieve a multipoint VPN
    Given an existing VPN with a known serviceId
    When I send a GET request to "/network/{serviceId}"
    Then the response status code is 200
    And the response body includes serviceId, connections, sla, and guaranteeBandwidth

  @getVpnConnection_02_not_found
  Scenario: Retrieve a non-existent VPN
    Given a serviceId that does not exist
    When I send a GET request to "/network/{serviceId}"
    Then the response status code is 404

  # updateNetwork - PATCH /network/{serviceId}

  @updateNetwork_01_success
  Scenario: Successfully update a multipoint VPN
    Given an existing VPN with a known serviceId
    And a valid NetworkUpdate request body with guaranteeBandwidth and sla
    When I send a PATCH request to "/network/{serviceId}"
    Then the response status code is 200
    And the response body reflects the updated guaranteeBandwidth and sla

  @updateNetwork_02_invalid_argument
  Scenario: Update VPN with out-of-range bandwidth
    Given an existing VPN with a known serviceId
    And a NetworkUpdate request body with guaranteeBandwidth of 0
    When I send a PATCH request to "/network/{serviceId}"
    Then the response status code is 400
    And the response property "$.code" is "INVALID_ARGUMENT"

  # deleteNetwork - DELETE /network/{serviceId}

  @deleteNetwork_01_success
  Scenario: Successfully delete a multipoint VPN
    Given an existing VPN with a known serviceId
    When I send a DELETE request to "/network/{serviceId}"
    Then the response status code is 202

  @deleteNetwork_02_unauthorized
  Scenario: Delete VPN without authentication
    Given the request does not include an access token
    When I send a DELETE request to "/network/{serviceId}"
    Then the response status code is 401
    And the response property "$.code" is "UNAUTHENTICATED"

  # assessConnectionFeasibility - POST /assessment

  @assessConnectionFeasibility_01_success
  Scenario: Successfully assess VPN connection feasibility
    Given a valid AssessmentRequest body with isProtected, connections, guaranteeBandwidth, and duration
    When I send a POST request to "/assessment"
    Then the response status code is 200
    And the response body includes waitdays, sla, and rent

  @assessConnectionFeasibility_02_invalid_argument
  Scenario: Assess feasibility with invalid SLA bandwidth
    Given an AssessmentRequest body with guaranteeBandwidth of 0
    When I send a POST request to "/assessment"
    Then the response status code is 400
    And the response property "$.code" is "INVALID_ARGUMENT"

  @assessConnectionFeasibility_03_unauthorized
  Scenario: Assess feasibility without authentication
    Given the request does not include an access token
    When I send a POST request to "/assessment"
    Then the response status code is 401
    And the response property "$.code" is "UNAUTHENTICATED"
