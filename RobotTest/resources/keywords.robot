*** Settings ***
Library    SeleniumLibrary
Library    String      
Library    Collections 
Library    OperatingSystem             
Resource    pageobjects.robot
Resource    ../config/config.robot

*** Keywords ***
GoTo bernieandphyls Page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window

Form Login Populate Fields
    [Arguments]    ${i_username}    ${i_password}
    Input Text    ${Page.Login.Username.Txt}    ${i_username}
    Input Text    ${Page.Login.Password.Txt}    ${i_password}

FirstPart
    ${ProductCategoryString}    (//span[contains(text(),'
    [Return]   ${ProductCategoryString}
    
GoTo bernieandphyls Page and Login
    Set Selenium Implicit Wait    30 seconds
    GoTo bernieandphyls Page
    Sleep  2
    Click Button   ${Page.Account.Login.Btn}
    Sleep  1
    click link    ${Page.primary.Login.Btn}
    Form Login Populate Fields    ${DEFAULT_USERNAME}    ${DEFAULT_PASSWORD}
    Click Button    ${Page.Login.Login.Btn}


Logout
    Click Element    ${Topbar.Profile.ProfileIcon.Link}    
    Wait Until Element Is Visible    ${Topbar.Profile.Logout.Link}    
    Click Element    ${Topbar.Profile.Logout.Link}  
#    Wait Until Element Is Visible    ${Popup.ReadyToLeave.Logout.Btn}
#    Click Element    ${Popup.ReadyToLeave.Logout.Btn}
    Close Browser

Get Table Headers
    [Documentation]    Header Text: Index pairs. Returns the generated dictionary.
    [Arguments]    ${i_table_locator}
    &{l_header_dict}    Create Dictionary    
    ${l_header_count}    Get Element Count    ${i_table_locator}/thead/tr/th
    FOR    ${l_header_index}    IN RANGE    1    ${l_header_count}+1    # +1 because ending range is exclusive
        ${l_header_text}    Get Text    ${i_table_locator}/thead/tr/th[${l_header_index}]
        Set To Dictionary    ${l_header_dict}    ${l_header_text}=${l_header_index}
    END
    [Return]    ${l_header_dict}    
        
Find Searched Row In The Table
    [Arguments]    ${i_table_locator}    ${i_dict_row}        
    &{l_header_dict}    Get Table Headers    ${i_table_locator}    
    ${l_search_row_keys}    Get Dictionary Keys    ${i_dict_row}
    ${l_search_row_items}    Get Dictionary Values    ${i_dict_row}    
    ${l_search_row_key1}    ${l_search_row_item1}    Set Variable    @{l_search_row_keys}[0]    @{l_search_row_items}[0]    
    
    FOR    ${key}    IN    @{l_search_row_keys}
        Dictionary Should Contain Key    ${l_header_dict}    ${key}    The header you are searching for does not exist in the table.
    END
                 
    ${l_header_index}    Set Variable    &{l_header_dict}[${l_search_row_key1}]
    ${l_row_count}    Get Element Count    ${i_table_locator}/tbody/tr
    ${l_row_found}    Set Variable    ${False}   
    FOR    ${row_index}    IN RANGE    2    ${l_row_count}+2
        ${row_item}    Get Table Cell    ${i_table_locator}    ${row_index}    ${l_header_index}
        ${l_row_found}    Run Keyword If    '${row_item}'=='${l_search_row_item1}'    Check Current Row    ${i_table_locator}    ${row_index}    ${l_header_dict}    ${l_search_row_keys}    ${l_search_row_items}
    ...    ELSE    Set Variable    ${False}
        Exit For Loop If    ${l_row_found}==${True}  
    END
    Run Keyword If    ${l_row_found}==${False}    Fail    Row not found
    ${index}    Set Variable    ${row_index-1}     
    [Return]    ${index}

Check Current Row
    [Arguments]    ${locator}    ${row_index}    ${header_dict}    ${search_row_keys}    ${search_row_items}
    ${row_found}    Set Variable    ${False}
    FOR    ${row_key}    ${row_item}	IN ZIP    ${search_row_keys}    ${search_row_items}
        ${header_index}    Set Variable    &{headerDict}[${row_key}]    # gets index based on the header text
        ${cell}    Get Table Cell    ${locator}    ${row_index}    ${header_index}              
        ${row_item_found}    Run Keyword And Return Status    Should Be Equal    ${row_item}    ${cell}
        ${row_found}    Set Variable If    ${row_item_found}==${True}    ${True}    ${False}
        Exit For Loop If    '${row_item_found}'=='False'
    END
    [Return]    ${row_found}

Get Validation Message
    [Arguments]    ${i_element}
    ${l_element}    Get WebElement    ${i_element}
    ${validationMessage}    Get Element Attribute    ${l_element}    validationMessage
    [Return]    ${validationMessage}

Get Validation Text
    [Arguments]    ${i_element}
    ${l_element}    Get WebElement    ${i_element}
    ${validationMessage}    get text    ${l_element}
    [Return]    ${validationMessage}


Load Json Data Into Dictionary
    [Arguments]    ${i_data}
    ${l_file}    Get File    ${i_data}
    ${l_data}    Evaluate    json.loads('''${l_file}''')    modules=json
    [Return]    ${l_data}

VERIFY
    [Arguments]    ${i_assertion_keyword}    ${i_args}    ${i_assertion_type}=1    ${i_pass_message}=${EMPTY}    ${i_fail_message}=${EMPTY}
    ${l_test_status}    ${l_test_message}    Run Keyword And Ignore Error    ${i_assertion_keyword}    @{i_args}  

    ${i_pass_message}    Set Variable If    '${i_pass_message}'=='${EMPTY}'    ${EMPTY}    > ${i_pass_message}\n
    Run Keyword If    '${l_test_status}'=='PASS'    Run Keywords
    ...    Set Test Message    ${i_pass_message}    append=yes
    ...    AND
    ...    Return From Keyword    ${l_test_status}   

    # Actions if test fails    
    ${i_fail_message}    Set Variable If    '${i_fail_message}'=='${EMPTY}'    ${l_test_message}    ${i_fail_message}            
    Run Keyword If    ${i_assertion_type}==1    Fail    ${i_fail_message}    
    ...    ELSE    Run Keyword And Continue On Failure    Fail    ${i_fail_message}       
    [Return]    ${l_test_status}

VERIFY FIELD VALIDATION
    [Arguments]    ${i_field_locator}    ${i_expected_validation_message}    
    ${l_validation_message}    Get Validation Message    ${i_field_locator}

    @{args}    Create List    ${l_validation_message}    ${i_expected_validation_message}
    VERIFY    Should Be Equal    ${args}
    ...    i_pass_message=Validation message "${i_expected_validation_message}" was displayed.
    ...    i_fail_message=Validation message "${i_expected_validation_message}" was not displayed.

Click Element By JavaScript Executor [Arguments] ${elementXpathLocator} ${retryScale}
    [Documentation]
    ...  Click an element by xpath using javascript executor  ...

    Wait Until Keyword Succeeds    2x     1 s    Wait Until Element Is Enabled    ${elementXpathLocator}
    Execute JavaScript  document.evaluate("${elementXpathLocator}", document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0).click();

VERIFY FIELD VALIDATIONTEXT
    [Arguments]    ${i_field_locator}    ${i_expected_validation_message}
    ${l_validation_message}    Get Validation Text    ${i_field_locator}

    @{args}    Create List    ${l_validation_message}    ${i_expected_validation_message}
    VERIFY    Should Be Equal    ${args}
    ...    i_pass_message=Validation message "${i_expected_validation_message}" was displayed.
    ...    i_fail_message=Validation message "${i_expected_validation_message}" was not displayed, Actual msg displayed "${l_validation_message}".


