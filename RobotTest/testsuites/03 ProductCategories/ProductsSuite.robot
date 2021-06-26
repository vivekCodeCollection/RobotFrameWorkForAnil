*** Settings ***
Resource    ../../templates/03 ProductCategories/template_Products.robot
Suite Setup    GoTo bernieandphyls Page and Login
#Suite Teardown    Logout
Test Template    Products Template

*** Test Cases ***
01 - Possitive Scenario - Search Product From Menu
    ${CURDIR}\\data\\PC1.json
