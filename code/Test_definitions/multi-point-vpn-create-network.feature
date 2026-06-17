Feature: CAMARA MultiPoint VPN API, v0.1.0-alpha.1 - Operation createNetwork

  Background:
    Given an environment at "apiRoot"
    And the resource "/multi-point-vpn/v0.1alpha1/networks"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"

  @multi_point_vpn_createNetwork_success_01_create_network
  Scenario: Successfully create a multipoint VPN network
    Given the request body complies with the schema at "#/components/schemas/NetworkCreate"
    And the request body property "$.isProtected" is set to true
    And the request body property "$.connections" contains at least one valid connection with customerEdge and providerEdge
    And the request body property "$.guaranteeBandwidth" is set to 20
    And the request body property "$.sla" is set to "AA"
    When the request "createNetwork" is sent
    Then the response status code is 201
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body complies with the schema at "#/components/schemas/Network"
    And the response property "$.serviceId" is present

  @multi_point_vpn_createNetwork_error_400_01_invalid_argument
  Scenario: Error 400 due to request body not complying with NetworkCreate schema
    Given the request body does not comply with the schema at "#/components/schemas/NetworkCreate"
    When the request "createNetwork" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_createNetwork_error_400_02_out_of_range_bandwidth
  Scenario: Error 400 due to guaranteeBandwidth value out of allowed range
    Given the request body property "$.guaranteeBandwidth" is set to a value not between 1 and 1000000
    When the request "createNetwork" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT" or "OUT_OF_RANGE"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_createNetwork_error_400_03_invalid_sla
  Scenario: Error 400 due to sla value not matching allowed enum
    Given the request body property "$.sla" is set to a value not in ["A", "AA", "AAA"]
    When the request "createNetwork" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_createNetwork_error_401_01_no_authorization_header
  Scenario: Error 401 when Authorization header is missing
    Given the header "Authorization" is removed
    When the request "createNetwork" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_createNetwork_error_401_02_expired_access_token
  Scenario: Error 401 when access token is expired
    Given the header "Authorization" is set to an expired access token
    When the request "createNetwork" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_createNetwork_error_403_01_missing_scope
  Scenario: Error 403 when access token lacks the multi-point-vpn:network:create scope
    Given the header "Authorization" is set to a valid access token without the "multi-point-vpn:network:create" scope
    When the request "createNetwork" is sent
    Then the response status code is 403
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_createNetwork_error_500_01_internal_server_error
  Scenario: Error 500 due to internal server error
    Given an internal server error occurs
    When the request "createNetwork" is sent
    Then the response status code is 500
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response property "$.status" is 500
    And the response property "$.code" is "INTERNAL"
    And the response property "$.message" contains a user friendly text
