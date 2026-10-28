Feature: CAMARA MultiPoint VPN API v0.1.0-alpha.1

  Background:
    Given an environment with CAMARA MultiPoint VPN API vwip
    And the request headers contain a valid access token with the required scope

  # checkFeasibility - POST /feasibility-check

  @multi_point_vpn_checkFeasibility_01_success
  Scenario: Successfully check MultiPoint VPN feasibility
    Given a valid FeasibilityRequest body with isProtected, connections, and guaranteedBandwidth as {value, unit}
    When I send a POST request to "/feasibility-check"
    Then the response status code is 200
    And the response body property "$.feasibilityStatus" is one of ["FEASIBLE", "FEASIBLE_WITH_CONDITIONS", "NOT_FEASIBLE"]

  @multi_point_vpn_checkFeasibility_02_invalid_argument
  Scenario: Check feasibility with missing required fields
    Given a FeasibilityRequest body with missing connections
    When I send a POST request to "/feasibility-check"
    Then the response status code is 400
    And the response property "$.code" is "INVALID_ARGUMENT"

  @multi_point_vpn_checkFeasibility_03_unauthorized
  Scenario: Check feasibility without authentication
    Given the request does not include an access token
    When I send a POST request to "/feasibility-check"
    Then the response status code is 401
    And the response property "$.code" is "UNAUTHENTICATED"

  # createNetwork - POST /networks

  @multi_point_vpn_createNetwork_01_success
  Scenario: Successfully create a MultiPoint VPN network
    Given a valid NetworkCreate request body with name, connections, and guaranteedBandwidth as {value, unit}
    When I send a POST request to "/networks"
    Then the response status code is 201
    And the response header "Location" is present
    And the response body includes networkId, name, status, connections, and guaranteedBandwidth

  @multi_point_vpn_createNetwork_02_invalid_argument
  Scenario: Create network with missing required fields
    Given a NetworkCreate request body with missing name
    When I send a POST request to "/networks"
    Then the response status code is 400
    And the response property "$.code" is "INVALID_ARGUMENT"

  @multi_point_vpn_createNetwork_03_unauthorized
  Scenario: Create network without authentication
    Given the request does not include an access token
    When I send a POST request to "/networks"
    Then the response status code is 401
    And the response property "$.code" is "UNAUTHENTICATED"

  @multi_point_vpn_createNetwork_04_service_not_applicable
  Scenario: Create network with endpoints for which service is not applicable
    Given a NetworkCreate request body with endpoints for which the service cannot be delivered
    When I send a POST request to "/networks"
    Then the response status code is 422
    And the response property "$.code" is "SERVICE_NOT_APPLICABLE"

  # getNetwork - GET /networks/{networkId}

  @multi_point_vpn_getNetwork_01_success
  Scenario: Successfully retrieve a MultiPoint VPN network
    Given an existing network with a known networkId
    When I send a GET request to "/networks/{networkId}"
    Then the response status code is 200
    And the response body includes networkId, name, status, connections, and guaranteedBandwidth

  @multi_point_vpn_getNetwork_02_not_found
  Scenario: Retrieve a non-existent network
    Given a networkId that does not exist
    When I send a GET request to "/networks/{networkId}"
    Then the response status code is 404
    And the response property "$.code" is "NOT_FOUND"

  # updateNetwork - PATCH /networks/{networkId}

  @multi_point_vpn_updateNetwork_01_success
  Scenario: Successfully update a MultiPoint VPN network
    Given an existing network with a known networkId
    And a valid NetworkUpdate request body with guaranteedBandwidth as {value, unit}
    When I send a PATCH request to "/networks/{networkId}"
    Then the response status code is 200
    And the response body reflects the updated guaranteedBandwidth

  @multi_point_vpn_updateNetwork_02_update_qos_profile
  Scenario: Successfully update qosProfile of a MultiPoint VPN network
    Given an existing network with a known networkId
    And a NetworkUpdate request body with qosProfile set to "premium"
    When I send a PATCH request to "/networks/{networkId}"
    Then the response status code is 200
    And the response property "$.qosProfile" is "premium"

  @multi_point_vpn_updateNetwork_03_invalid_argument
  Scenario: Update network with out-of-range bandwidth value
    Given an existing network with a known networkId
    And a NetworkUpdate request body with guaranteedBandwidth.value of 0
    When I send a PATCH request to "/networks/{networkId}"
    Then the response status code is 400
    And the response property "$.code" is "INVALID_ARGUMENT"

  # deleteNetwork - DELETE /networks/{networkId}

  @multi_point_vpn_deleteNetwork_01_success
  Scenario: Successfully delete a MultiPoint VPN network
    Given an existing network with a known networkId
    When I send a DELETE request to "/networks/{networkId}"
    Then the response status code is 202

  @multi_point_vpn_deleteNetwork_02_unauthorized
  Scenario: Delete network without authentication
    Given the request does not include an access token
    When I send a DELETE request to "/networks/{networkId}"
    Then the response status code is 401
    And the response property "$.code" is "UNAUTHENTICATED"

  # listConnections - GET /networks/{networkId}/connections

  @multi_point_vpn_listConnections_01_success
  Scenario: Successfully list connections of a MultiPoint VPN network
    Given an existing network with a known networkId
    When I send a GET request to "/networks/{networkId}/connections"
    Then the response status code is 200
    And the response body is an array of Connection objects each with a connectionId

  @multi_point_vpn_listConnections_02_not_found
  Scenario: List connections for a non-existent network
    Given a networkId that does not exist
    When I send a GET request to "/networks/{networkId}/connections"
    Then the response status code is 404
    And the response property "$.code" is "NOT_FOUND"

  # addConnection - POST /networks/{networkId}/connections

  @multi_point_vpn_addConnection_01_success
  Scenario: Successfully add a connection to a MultiPoint VPN network
    Given an existing network with a known networkId
    And a valid ConnectionCreate request body with customerEdge and providerEdge
    When I send a POST request to "/networks/{networkId}/connections"
    Then the response status code is 201
    And the response header "Location" is present
    And the response body includes connectionId, customerEdge, and providerEdge

  @multi_point_vpn_addConnection_02_invalid_argument
  Scenario: Add connection with missing required fields
    Given an existing network with a known networkId
    And a ConnectionCreate request body with missing providerEdge
    When I send a POST request to "/networks/{networkId}/connections"
    Then the response status code is 400
    And the response property "$.code" is "INVALID_ARGUMENT"

  @multi_point_vpn_addConnection_03_not_found
  Scenario: Add connection to a non-existent network
    Given a networkId that does not exist
    When I send a POST request to "/networks/{networkId}/connections"
    Then the response status code is 404
    And the response property "$.code" is "NOT_FOUND"

  # removeConnection - DELETE /networks/{networkId}/connections/{connectionId}

  @multi_point_vpn_removeConnection_01_success
  Scenario: Successfully remove a connection from a MultiPoint VPN network
    Given an existing network with a known networkId
    And an existing connectionId within that network
    When I send a DELETE request to "/networks/{networkId}/connections/{connectionId}"
    Then the response status code is 202

  @multi_point_vpn_removeConnection_02_not_found
  Scenario: Remove a non-existent connection
    Given an existing network with a known networkId
    And a connectionId that does not exist within that network
    When I send a DELETE request to "/networks/{networkId}/connections/{connectionId}"
    Then the response status code is 404
    And the response property "$.code" is "NOT_FOUND"
