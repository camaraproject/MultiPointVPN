Feature: CAMARA MultiPoint VPN API, vwip - Operation checkFeasibility

  Background:
    Given an environment at "apiRoot"
    And the resource "/multi-point-vpn/vwip/feasibility-check"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the request body is compliant with the schema at "#/components/schemas/FeasibilityRequest"

  @multi_point_vpn_checkFeasibility_success_01_feasibility_result
  Scenario: Successfully check MultiPoint VPN feasibility
    Given the request body property "$.isProtected" is set to true
    And the request body property "$.connections" contains a valid connection with customerEdge and providerEdge
    And the request body property "$.guaranteedBandwidth.value" is set to 20
    And the request body property "$.guaranteedBandwidth.unit" is set to "Mbps"
    And the request body property "$.servicePeriod.startDate" is set to a valid RFC 3339 date-time with timezone
    When the request "checkFeasibility" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body complies with the schema at "#/components/schemas/FeasibilityResult"
    And the response property "$.feasibilityStatus" is one of ["FEASIBLE", "FEASIBLE_WITH_CONDITIONS", "NOT_FEASIBLE"]

  @multi_point_vpn_checkFeasibility_error_400_01_invalid_request_body
  Scenario: Error 400 due to request body not complying with FeasibilityRequest schema
    Given the request body does not comply with the schema at "#/components/schemas/FeasibilityRequest"
    When the request "checkFeasibility" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_checkFeasibility_error_400_02_out_of_range_bandwidth
  Scenario: Error 400 due to guaranteedBandwidth value out of allowed range
    Given the request body property "$.guaranteedBandwidth.value" is set to a value not between 1 and 100000
    When the request "checkFeasibility" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT" or "OUT_OF_RANGE"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_checkFeasibility_error_400_03_invalid_bandwidth_unit
  Scenario: Error 400 due to guaranteedBandwidth unit not matching allowed enum
    Given the request body property "$.guaranteedBandwidth.unit" is set to a value not in ["Mbps", "Gbps"]
    When the request "checkFeasibility" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_checkFeasibility_error_400_04_unknown_property
  Scenario: Error 400 due to unknown property in request body
    Given the request body contains a property not declared in the FeasibilityRequest schema
    When the request "checkFeasibility" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_checkFeasibility_error_401_01_no_authorization_header
  Scenario: Error 401 when Authorization header is missing
    Given the header "Authorization" is removed
    When the request "checkFeasibility" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_checkFeasibility_error_401_02_expired_access_token
  Scenario: Error 401 when access token is expired
    Given the header "Authorization" is set to an expired access token
    When the request "checkFeasibility" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_checkFeasibility_error_403_01_missing_scope
  Scenario: Error 403 when access token lacks the multi-point-vpn:feasibility-check scope
    Given the header "Authorization" is set to a valid access token without the "multi-point-vpn:feasibility-check" scope
    When the request "checkFeasibility" is sent
    Then the response status code is 403
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_checkFeasibility_error_500_01_internal_server_error
  Scenario: Error 500 due to internal server error
    Given an internal server error occurs
    When the request "checkFeasibility" is sent
    Then the response status code is 500
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response property "$.status" is 500
    And the response property "$.code" is "INTERNAL"
    And the response property "$.message" contains a user friendly text
