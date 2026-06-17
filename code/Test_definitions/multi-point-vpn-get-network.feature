Feature: CAMARA MultiPoint VPN API, vwip - Operation getNetwork

  Background:
    Given an environment at "apiRoot"
    And the resource "/multi-point-vpn/vwip/networks/{serviceId}"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"

  @multi_point_vpn_getNetwork_success_01_get_network_details
  Scenario: Successfully retrieve multipoint VPN network details
    Given the path parameter "serviceId" is set to an existing network identifier
    When the request "getNetwork" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body complies with the schema at "#/components/schemas/Network"
    And the response property "$.serviceId" is present

  @multi_point_vpn_getNetwork_error_400_01_invalid_serviceId
  Scenario: Error 400 due to serviceId not complying with the allowed pattern
    Given the path parameter "serviceId" does not comply with the schema at "#/components/parameters/serviceId"
    When the request "getNetwork" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_getNetwork_error_401_01_no_authorization_header
  Scenario: Error 401 when Authorization header is missing
    Given the header "Authorization" is removed
    And the path parameter "serviceId" is set to an existing network identifier
    When the request "getNetwork" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_getNetwork_error_401_02_expired_access_token
  Scenario: Error 401 when access token is expired
    Given the header "Authorization" is set to an expired access token
    And the path parameter "serviceId" is set to an existing network identifier
    When the request "getNetwork" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_getNetwork_error_403_01_missing_scope
  Scenario: Error 403 when access token lacks the multi-point-vpn:network:read scope
    Given the header "Authorization" is set to a valid access token without the "multi-point-vpn:network:read" scope
    And the path parameter "serviceId" is set to an existing network identifier
    When the request "getNetwork" is sent
    Then the response status code is 403
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_getNetwork_error_404_01_network_not_found
  Scenario: Error 404 when the requested network does not exist
    Given the path parameter "serviceId" is set to a non-existent network identifier
    When the request "getNetwork" is sent
    Then the response status code is 404
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_getNetwork_error_500_01_internal_server_error
  Scenario: Error 500 due to internal server error
    Given an internal server error occurs
    And the path parameter "serviceId" is set to an existing network identifier
    When the request "getNetwork" is sent
    Then the response status code is 500
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response property "$.status" is 500
    And the response property "$.code" is "INTERNAL"
    And the response property "$.message" contains a user friendly text
