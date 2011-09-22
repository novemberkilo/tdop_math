Feature: Algebraic Equation Parser
  In order to make sense of user entered algebraic equations
  I want to have an algebraic equation parser

  Background:
    Given I have loaded the tdop_math

  Scenario Outline: Run some calculations
    When I ask the tdop_math for the answer to "<input>"
    Then I should see string <result>


    Examples:
      | input                   |                                   result |
      | sin(cos(sin(pi)))       | "Math.sin(Math.cos(Math.sin(Math::PI)))" |
      | sin(cos(pi))            |           "Math.sin(Math.cos(Math::PI))" |
      | sin(sqrt(0))            |                 "Math.sin(Math.sqrt(0))" |
      | 24                      |                                     "24" |
      | 1.5                     |                                    "1.5" |
      | pi                      |                               "Math::PI" |
      | pi - 3.141592653589793  |           "Math::PI - 3.141592653589793" |
      | 24 +2                   |                                 "24 + 2" |
      | 24 + 2 * 3              |                             "24 + 2 * 3" |
      | 24+2* - 3-12            |                 "24 + 2 * (-1 * 3) - 12" |
      | 24+2*(-3-12)            |               "24 + 2 * ((-1 * 3) - 12)" |
      | 24+2*-(3-12)            |               "24 + 2 * (-1 * (3 - 12))" |
      | 24+2*-(3-12^2)          |            "24 + 2 * (-1 * (3 - 12**2))" |
      | 24+3*4/2 - 5            |                     "24 + 3 * 4 / 2 - 5" |
      | 6+sqrt(9)               |                       "6 + Math.sqrt(9)" |
      | sin(0)                  |                            "Math.sin(0)" |
      | cos(0)                  |                            "Math.cos(0)" |
      | cos(pi)                 |                     "Math.cos(Math::PI)" |
      | 2pi                     |                           "2 * Math::PI" |
      | cos(2pi)                |                 "Math.cos(2 * Math::PI)" |
      | 2t                      |                                  "2 * t" |
      | cos(t)                  |                            "Math.cos(t)" |
      | sin(cos(sqrt(2t)))      |   "Math.sin(Math.cos(Math.sqrt(2 * t)))" |


  Scenario Outline: Evaluated calcs
    When I evaluate the tdop_math answer to "<input>"
    Then I should see "<result>"

    Examples:
      | input                   |                     result |
      | sin(cos(sin(pi)))       |     0.841470984807896506652|
      | sin(cos(pi))            |    -0.841470984807896506652|
      | sin(sqrt(0))            |                          0 |
      | 24                      |                         24 |
      | 1.5                     |                        1.5 |
      | pi                      |          3.141592653589793 |
      | pi - 3.141592653589793  |                          0 |
      | 24 +2                   |                         26 |
      | 24 + 2 * 3              |                         30 |
      | 24+2* - 3-12            |                          6 |
      | 24+2*(-3-12)            |                         -6 |
      | 24+2*-(3-12)            |                         42 |
      | 24+2*-(3-12^2)          |                        306 |
      | 24+3*4/2 - 5            |                         25 |
      | 6+sqrt(9)               |                          9 |
      | sin(0)                  |                          0 |
      | cos(0)                  |                          1 |
      | cos(pi)                 |                         -1 |
      | 2pi                     |          6.283185307179586 |
      | cos(2pi)                |                          1 |

  Scenario: Leading whitespace
    When I ask the algebraic equation parser for the answer to "  2+2"
    Then I should see string "2 + 2"

  Scenario: Trailing whitespace
    When I ask the algebraic equation parser for the answer to "2+2  "
    Then I should see string "2 + 2"

  #Scenario: Odd whitespace characters
    #When I ask the algebraic equation parser for the answer to " \t \n 2 \r\n + \t - \r 2 \n"
    #Then I should see "0"

  Scenario Outline: Syntax errors
    When I ask the algebraic equation parser for the answer to "<input>"
    Then I should get the error "<message>"

    Examples:
      | input   | message                               |
      |         | Unexpected end of input               |
      | 2+      | Unexpected end of input               |
      | +2      | Unexpected '+'                        |
      | 2 2     | Unexpected integer (2)                |
      | 2+(3    | Unexpected end of input; expected ')' |
      | 2+)3    | Unexpected ')'                        |
      | 2+*3    | Unexpected '*'                        |
      | 2-      | Unexpected end of input               |
      | 3-18(4) | Unrecognized function                 |
      | sqrt(8  | Missing closing parenthesis           |
      | foo(8)  | Unknown symbol                        |
      | sqrt(a) | Unknown symbol                        |
      |  2d     | Unknown symbol                        |
      |  foo    | Unknown symbol                        |
