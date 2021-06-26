*** Settings ***
Resource    ../../templates/02 Registration/template_Registration.robot
Suite Setup    GoTo bernieandphyls Page
Suite Teardown    Logout
Test Template    Registration Template


*** Test Cases ***
01 - Possitive Scenario - Successfull Registration
    ${CURDIR}\\data\\R1.json