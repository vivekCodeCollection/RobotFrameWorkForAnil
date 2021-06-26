*** Settings ***
Resource    ../../resources/keywords.robot
Library  String

*** Variables ***
${Emailxtension}   @gmail.com


*** Keywords ***
Registration Template
     [Arguments]    ${i_data}
     ${l_data}    Load Json Data Into Dictionary    ${i_data}
     Sleep  2
     Click Button   ${Page.Account.Login.Btn}
     Sleep  1
     click link   ${Page.Registration.CreateAnAcount.Link}
     RegistrationPersonalInformation  ${l_data['FirstName']['input']}   ${l_data['LastName']['input']}
     ${val}    RandomStringGenration
     RegistrationSignInInformation   ${l_data['Email']['input']}${val}${Emailxtension}    ${l_data['PassWordAndConfirmPassWord']['input']}    ${l_data['PassWordAndConfirmPassWord']['input']}
     Wait Until Element Is Visible   ${Page.Registration.RemeberMe.Chkbox}
     Sleep  2
     Execute JavaScript    window.scrollTo(0, 700)
     Sleep  2
     double click element  ${Page.Registration.CreateAccount.Btn}
     @{args}    Create List    ${l_data['expectedTextInPage']}
     VERIFY    Page Should Contain    ${args}


RegistrationPersonalInformation
   [Arguments]    ${i_firstName}    ${i_lastName}
   Input Text    ${Page.Registration.FirstName.Input}   ${i_firstName}
   Input Text    ${Page.Registration.LastName.Input}   ${i_lastName}

RegistrationSignInInformation
   [Arguments]    ${i_email}   ${i_passWord}   ${i_ConfirmpassWord}
   Input Text    ${Page.Registration.Email.Input}     ${i_email}
   Input Text    ${Page.Registration.Password.Input}   ${i_passWord}
   Input Text    ${Page.Registration.ConfirmPassword.Input}   ${i_ConfirmpassWord}

RandomStringGenration
    ${Random_Number}    Generate random string    4    0123456789
    [Return]    ${Random_Number}