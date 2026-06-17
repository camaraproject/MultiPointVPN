Feature: CAMARA MultiPoint VPN API v0.1.0-alpha.1

  Background:
    Given an environment with CAMARA MultiPoint VPN API
    And the request headers contain a valid access token with the required scope

  # createNetwork - POST /networks

  @multi_point_vpn_createNetwork_01_success
  Scenario: Successfully create a multipoint VPN
    Given a valid NetworkCreate request body with serviceName, isProtected, connections, guaranteeBandwidth, sla, and duration
    When I send a POST request to "/networks"
    Then the response status code is 201
    And the response body includes serviceId, connections, resourceGroupId, and cloudGatewayIp

  @multi_point_vpn_createNetwork_02_invalid_argument
  Scenario: Create VPN with missing required fields
    Given a NetworkCreate request body with missing connections
    When I send a POST request to "/networks"
    Then the response status code is 400
    And the response property "$.code" is "INVALID_ARGUMENT"

  @multi_point_vpn_createNetwork_03_unauthorized
  Scenario: Create VPN without authentication
    Given the request does not include an access token
    When I send a POST request to "/networks"
    Then the response status code is 401
    And the response property "$.code" is "UNAUTHENTICATED"

  # getNetwork - GET /networks/{serviceId}

  @multi_point_vpn_getNetwork_01_success
  Scenario: Successfully retrieve a multipoint VPN
    Given an existing VPN with a known serviceId
    When I send a GET request to "/networks/{serviceId}"
    Then the response status code is 200
    And the response body includes serviceId, connections, sla, and guaranteeBandwidth

  @multi_point_vpn_getNetwork_02_not_found
  Scenario: Retrieve a non-existent VPN
    Given a serviceId that does not exist
    When I send a GET request to "/networks/{serviceId}"
    Then the response status code is 404
    And the response property "$.code" is "NOT_FOUND"

  # updateNetwork - PATCH /networks/{serviceId}

  @multi_point_vpn_updateNetwork_01_success
  Scenario: Successfully update a multipoint VPN
    Given an existing VPN with a known serviceId
    And a valid NetworkUpdate request body with guaranteeBandwidth and sla
    When I send a PATCH request to "/networks/{serviceId}"
    Then the response status code is 200
    And the response body reflects the updated guaranteeBandwidth and sla

  @multi_point_vpn_updateNetwork_02_invalid_argument
  Scenario: Update VPN with out-of-range bandwidth
    Given an existing VPN with a known serviceId
    And a NetworkUpdate request body with guaranteeBandwidth of 0
    When I send a PATCH request to "/networks/{serviceId}"
    Then the response status code is 400
    And the response property "$.code" is "INVALID_ARGUMENT"

  # deleteNetwork - DELETE /networks/{serviceId}

  @multi_point_vpn_deleteNetwork_01_success
  Scenario: Successfully delete a multipoint VPN
    Given an existing VPN with a known serviceId
    When I send a DELETE request to "/networks/{serviceId}"
    Then the response status code is 202

  @multi_point_vpn_deleteNetwork_02_unauthorized
  Scenario: Delete VPN without authentication
    Given the request does not include an access token
    When I send a DELETE request to "/networks/{serviceId}"
    Then the response status code is 401
    And the response property "$.code" is "UNAUTHENTICATED"

  # assessConnectionFeasibility - POST /assessment

  @multi_point_vpn_assessConnectionFeasibility_01_success
  Scenario: Successfully assess VPN connection feasibility
    Given a valid AssessmentRequest body with isProtected, connections, guaranteeBandwidth, and duration
    When I send a POST request to "/assessment"
    Then the response status code is 200
    And the response body includes waitDays, sla, and rent

  @multi_point_vpn_assessConnectionFeasibility_02_invalid_argument
  Scenario: Assess feasibility with invalid bandwidth
    Given an AssessmentRequest body with guaranteeBandwidth of 0
    When I send a POST request to "/assessment"
    Then the response status code is 400
    And the response property "$.code" is "INVALID_ARGUMENT"

  @multi_point_vpn_assessConnectionFeasibility_03_unauthorized
  Scenario: Assess feasibility without authentication
    Given the request does not include an access token
    When I send a POST request to "/assessment"
    Then the response status code is 401
    And the response property "$.code" is "UNAUTHENTICATED"
