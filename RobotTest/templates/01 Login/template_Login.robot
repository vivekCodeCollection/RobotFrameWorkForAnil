*** Settings ***
Resource    ../../resources/keywords.robot

*** Keywords ***
Login Template
    [Arguments]    ${i_data}
    ${l_data}    Load Json Data Into Dictionary    ${i_data}
    Sleep  2
    Click Button   ${Page.Account.Login.Btn}
    Sleep  1
    click link    ${Page.primary.Login.Btn}
    Form Login Populate Fields    ${l_data['username']['input']}    ${l_data['password']['input']}
    Click Button    ${Page.Login.Login.Btn}
    
    Run Keyword If    '${l_data['username']['validationMessage']}'!='${EMPTY}'
    ...    VERIFY FIELD VALIDATIONTEXT    xpath=${l_data['username']['UserErrorElement']}    ${l_data['username']['validationMessage']}

    Run Keyword If    '${l_data['password']['validationMessage']}'!='${EMPTY}'
    ...    VERIFY FIELD VALIDATIONTEXT    xpath=${l_data['password']['PwdErrorElement']}    ${l_data['password']['validationMessage']}

    @{args}    Create List    ${l_data['expectedTextInPage']}        
    VERIFY    Page Should Contain    ${args}    
     