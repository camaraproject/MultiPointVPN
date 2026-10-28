Feature: CAMARA MultiPoint VPN API, vwip - Connection Operations

  Background:
    Given an environment at "apiRoot"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"

  # listConnections - GET /networks/{networkId}/connections

  @multi_point_vpn_listConnections_success_01_list_connections
  Scenario: Successfully list connections of a MultiPoint VPN network
    Given the resource "/multi-point-vpn/vwip/networks/{networkId}/connections"
    And the path parameter "networkId" is set to an existing network identifier
    When the request "listConnections" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body is an array of items complying with the schema at "#/components/schemas/Connection"
    And each item in the response array has a "connectionId" property

  @multi_point_vpn_listConnections_error_401_01_no_authorization_header
  Scenario: Error 401 when Authorization header is missing for listConnections
    Given the resource "/multi-point-vpn/vwip/networks/{networkId}/connections"
    And the header "Authorization" is removed
    And the path parameter "networkId" is set to an existing network identifier
    When the request "listConnections" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_listConnections_error_403_01_missing_scope
  Scenario: Error 403 when access token lacks the multi-point-vpn:networks:read scope for listConnections
    Given the resource "/multi-point-vpn/vwip/networks/{networkId}/connections"
    And the header "Authorization" is set to a valid access token without the "multi-point-vpn:networks:read" scope
    And the path parameter "networkId" is set to an existing network identifier
    When the request "listConnections" is sent
    Then the response status code is 403
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_listConnections_error_404_01_network_not_found
  Scenario: Error 404 when the network does not exist for listConnections
    Given the resource "/multi-point-vpn/vwip/networks/{networkId}/connections"
    And the path parameter "networkId" is set to a non-existent network identifier
    When the request "listConnections" is sent
    Then the response status code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  # addConnection - POST /networks/{networkId}/connections

  @multi_point_vpn_addConnection_success_01_add_connection
  Scenario: Successfully add a connection to a MultiPoint VPN network
    Given the resource "/multi-point-vpn/vwip/networks/{networkId}/connections"
    And the header "Content-Type" is set to "application/json"
    And the path parameter "networkId" is set to an existing network identifier
    And the request body complies with the schema at "#/components/schemas/ConnectionCreate"
    And the request body property "$.customerEdge.type" is set to "site"
    And the request body property "$.customerEdge.primaryIpAddress.addressType" is set to "Ipv4Address"
    And the request body property "$.customerEdge.primaryIpAddress.address" is set to a valid IPv4 address
    And the request body property "$.providerEdge.type" is set to "cloud"
    And the request body property "$.providerEdge.primaryIpAddress.addressType" is set to "Ipv4Address"
    And the request body property "$.providerEdge.primaryIpAddress.address" is set to a valid IPv4 address
    When the request "addConnection" is sent
    Then the response status code is 201
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response header "Location" is present and contains the URL of the created connection resource
    And the response body complies with the schema at "#/components/schemas/Connection"
    And the response property "$.connectionId" is present

  @multi_point_vpn_addConnection_error_400_01_invalid_request_body
  Scenario: Error 400 due to request body not complying with ConnectionCreate schema
    Given the resource "/multi-point-vpn/vwip/networks/{networkId}/connections"
    And the header "Content-Type" is set to "application/json"
    And the path parameter "networkId" is set to an existing network identifier
    And the request body does not comply with the schema at "#/components/schemas/ConnectionCreate"
    When the request "addConnection" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_addConnection_error_400_02_unknown_property
  Scenario: Error 400 due to unknown property in addConnection request body
    Given the resource "/multi-point-vpn/vwip/networks/{networkId}/connections"
    And the header "Content-Type" is set to "application/json"
    And the path parameter "networkId" is set to an existing network identifier
    And the request body contains a property not declared in the ConnectionCreate schema
    When the request "addConnection" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_addConnection_error_401_01_no_authorization_header
  Scenario: Error 401 when Authorization header is missing for addConnection
    Given the resource "/multi-point-vpn/vwip/networks/{networkId}/connections"
    And the header "Authorization" is removed
    And the path parameter "networkId" is set to an existing network identifier
    When the request "addConnection" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_addConnection_error_403_01_missing_scope
  Scenario: Error 403 when access token lacks the multi-point-vpn:networks:update scope for addConnection
    Given the resource "/multi-point-vpn/vwip/networks/{networkId}/connections"
    And the header "Authorization" is set to a valid access token without the "multi-point-vpn:networks:update" scope
    And the path parameter "networkId" is set to an existing network identifier
    When the request "addConnection" is sent
    Then the response status code is 403
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_addConnection_error_404_01_network_not_found
  Scenario: Error 404 when the network does not exist for addConnection
    Given the resource "/multi-point-vpn/vwip/networks/{networkId}/connections"
    And the path parameter "networkId" is set to a non-existent network identifier
    When the request "addConnection" is sent
    Then the response status code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_addConnection_error_422_01_service_not_applicable
  Scenario: Error 422 when the service cannot be delivered for the provided connection endpoints
    Given the resource "/multi-point-vpn/vwip/networks/{networkId}/connections"
    And the path parameter "networkId" is set to an existing network identifier
    And the request body connections reference endpoints for which the service is not applicable
    When the request "addConnection" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "SERVICE_NOT_APPLICABLE"
    And the response property "$.message" contains a user friendly text

  # removeConnection - DELETE /networks/{networkId}/connections/{connectionId}

  @multi_point_vpn_removeConnection_success_01_remove_accepted
  Scenario: Successfully request removal of a connection from a MultiPoint VPN network
    Given the resource "/multi-point-vpn/vwip/networks/{networkId}/connections/{connectionId}"
    And the path parameter "networkId" is set to an existing network identifier
    And the path parameter "connectionId" is set to an existing connection identifier within that network
    When the request "removeConnection" is sent
    Then the response status code is 202
    And the response header "x-correlator" has the same value as the request header "x-correlator"

  @multi_point_vpn_removeConnection_error_401_01_no_authorization_header
  Scenario: Error 401 when Authorization header is missing for removeConnection
    Given the resource "/multi-point-vpn/vwip/networks/{networkId}/connections/{connectionId}"
    And the header "Authorization" is removed
    And the path parameter "networkId" is set to an existing network identifier
    And the path parameter "connectionId" is set to an existing connection identifier
    When the request "removeConnection" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_removeConnection_error_403_01_missing_scope
  Scenario: Error 403 when access token lacks the multi-point-vpn:networks:update scope for removeConnection
    Given the resource "/multi-point-vpn/vwip/networks/{networkId}/connections/{connectionId}"
    And the header "Authorization" is set to a valid access token without the "multi-point-vpn:networks:update" scope
    And the path parameter "networkId" is set to an existing network identifier
    And the path parameter "connectionId" is set to an existing connection identifier
    When the request "removeConnection" is sent
    Then the response status code is 403
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_removeConnection_error_404_01_network_not_found
  Scenario: Error 404 when the network does not exist for removeConnection
    Given the resource "/multi-point-vpn/vwip/networks/{networkId}/connections/{connectionId}"
    And the path parameter "networkId" is set to a non-existent network identifier
    And the path parameter "connectionId" is set to any connection identifier
    When the request "removeConnection" is sent
    Then the response status code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_removeConnection_error_404_02_connection_not_found
  Scenario: Error 404 when the connection does not exist within the network for removeConnection
    Given the resource "/multi-point-vpn/vwip/networks/{networkId}/connections/{connectionId}"
    And the path parameter "networkId" is set to an existing network identifier
    And the path parameter "connectionId" is set to a non-existent connection identifier
    When the request "removeConnection" is sent
    Then the response status code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_removeConnection_error_500_01_internal_server_error
  Scenario: Error 500 due to internal server error for removeConnection
    Given the resource "/multi-point-vpn/vwip/networks/{networkId}/connections/{connectionId}"
    And an internal server error occurs
    And the path parameter "networkId" is set to an existing network identifier
    And the path parameter "connectionId" is set to an existing connection identifier
    When the request "removeConnection" is sent
    Then the response status code is 500
    And the response property "$.status" is 500
    And the response property "$.code" is "INTERNAL"
    And the response property "$.message" contains a user friendly text
