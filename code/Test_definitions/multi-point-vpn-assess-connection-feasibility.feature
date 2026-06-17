Feature: CAMARA MultiPoint VPN API, v0.1.0-alpha.1 - Operation assessConnectionFeasibility

  Background:
    Given an environment at "apiRoot"
    And the resource "/multi-point-vpn/v0.1alpha1/assessment"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the request body is compliant with the schema at "#/components/schemas/AssessmentRequest"

  @multi_point_vpn_assessConnectionFeasibility_success_01_assessment_result
  Scenario: Successfully assess multipoint VPN connection feasibility
    Given the request body property "$.isProtected" is set to true
    And the request body property "$.connections" contains a valid connection with customerEdge and providerEdge
    And the request body property "$.guaranteeBandwidth" is set to 20
    And the request body property "$.duration" is set to a valid Duration object with value 6 and unit "days"
    When the request "assessConnectionFeasibility" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body complies with the schema at "#/components/schemas/AssessmentResult"

  @multi_point_vpn_assessConnectionFeasibility_error_400_01_invalid_request_body
  Scenario: Error 400 due to request body not complying with AssessmentRequest schema
    Given the request body does not comply with the schema at "#/components/schemas/AssessmentRequest"
    When the request "assessConnectionFeasibility" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_assessConnectionFeasibility_error_400_02_out_of_range_bandwidth
  Scenario: Error 400 due to guaranteeBandwidth value out of allowed range
    Given the request body property "$.guaranteeBandwidth" is set to a value not between 1 and 1000000
    When the request "assessConnectionFeasibility" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT" or "OUT_OF_RANGE"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_assessConnectionFeasibility_error_400_03_invalid_duration_unit
  Scenario: Error 400 due to duration unit not matching allowed enum
    Given the request body property "$.duration.unit" is set to a value not in ["minutes", "hours", "days", "months", "years"]
    When the request "assessConnectionFeasibility" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_assessConnectionFeasibility_error_401_01_no_authorization_header
  Scenario: Error 401 when Authorization header is missing
    Given the header "Authorization" is removed
    When the request "assessConnectionFeasibility" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_assessConnectionFeasibility_error_401_02_expired_access_token
  Scenario: Error 401 when access token is expired
    Given the header "Authorization" is set to an expired access token
    When the request "assessConnectionFeasibility" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_assessConnectionFeasibility_error_403_01_missing_scope
  Scenario: Error 403 when access token lacks the multi-point-vpn:assessment:assess scope
    Given the header "Authorization" is set to a valid access token without the "multi-point-vpn:assessment:assess" scope
    When the request "assessConnectionFeasibility" is sent
    Then the response status code is 403
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @multi_point_vpn_assessConnectionFeasibility_error_500_01_internal_server_error
  Scenario: Error 500 due to internal server error
    Given an internal server error occurs
    When the request "assessConnectionFeasibility" is sent
    Then the response status code is 500
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response property "$.status" is 500
    And the response property "$.code" is "INTERNAL"
    And the response property "$.message" contains a user friendly text
