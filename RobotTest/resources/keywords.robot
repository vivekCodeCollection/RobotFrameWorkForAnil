*** Settings ***
Library    SeleniumLibrary
Library    String      
Library    Collections 
Library    OperatingSystem             
Resource    pageobjects.robot
Resource    ../config/config.robot

*** Keywords ***
GoTo Cloud Bank Page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window

Form Login Populate Fields
    [Arguments]    ${i_username}    ${i_password}
    Input Text    ${Page.Login.Username.Txt}    ${i_username}
    Input Text    ${Page.Login.Password.Txt}    ${i_password}
    
GoTo Cloud Bank Page and Login
    [Arguments]    ${i_username}    ${i_password}
    Set Selenium Implicit Wait    30 seconds
    GoTo Cloud Bank Page
    Form Login Populate Fields    ${i_username}    ${i_password}
    Click Button    ${Page.Login.Login.Btn}

# Dashboard Keywords
GoTo Dashboard
    Click Element    ${Sidebar.CloudBank.Dashboard.Link}
    @{args}    Create List    //h1[contains(text(),'Dashboard')]
    VERIFY    Page Should Contain Element    ${args}        

Get Dashboard Aggregate Deposit Value
    ${l_amount_txt}    Get Text    ${Page.Dashboard.AggregateDeposit.Lbl}
    ${l_amount_txt}    Remove String    ${l_amount_txt}     PHP
    ${l_amount_txt}    Convert To Number    ${l_amount_txt}
    [Return]    ${l_amount_txt} 

Get Dashboard Aggregate Withdraw Value
    ${l_amount_txt}    Get Text    ${Page.Dashboard.AggregateWithdraw.Lbl}
    ${l_amount_txt}    Remove String    ${l_amount_txt}     PHP
    ${l_amount_txt}    Convert To Number    ${l_amount_txt}
    [Return]    ${l_amount_txt}

Get Dashboard Aggregate Transfer Value
    ${l_amount_txt}    Get Text    ${Page.Dashboard.AggregateTransfer.Lbl}
    ${l_amount_txt}    Remove String    ${l_amount_txt}     PHP
    ${l_amount_txt}    Convert To Number    ${l_amount_txt}
    [Return]    ${l_amount_txt}

Get Dashboard Number Of Transactions Value
    ${l_number_of_trx}    Get Text    ${Page.Dashboard.NumberOfTransactions.Lbl}
    ${l_number_of_trx}    Convert To Number    ${l_number_of_trx}    
    [Return]    ${l_number_of_trx} 
    
# System User Keywords
GoTo Create System User Form
    Click Element    ${Sidebar.StaticData.SystemUsers.Link}      
    Wait Until Element Is Visible    ${Sidebar.StaticData.NewSystemUser.Link}       
    Click Element    ${Sidebar.StaticData.NewSystemUser.Link} 

GoTo View/Update/Delete System User Form
    [Arguments]    ${i_row}
    Click Element    ${Sidebar.StaticData.SystemUsers.Link}      
    Wait Until Element Is Visible    ${Sidebar.StaticData.NewSystemUser.Link}       
    Click Element    ${Sidebar.StaticData.SystemUserList.Link}
    ${l_index}    Find Searched Row In The Table    ${Page.Common.ObjectListTable.Tbl}    ${i_row}
    Click Element    ${Page.Common.ObjectListTable.Tbl}/tbody/tr[${l_index}]/td[1]/a
    
Form System User Populate Fields
    [Arguments]    ${i_username}=${EMPTY}    ${i_password}=${EMPTY}    ${i_password_confirmation}=${EMPTY}
    Run Keyword If    '${i_username}'!='${EMPTY}'    Input Text    ${Form.SystemUser.Username.Txt}    ${i_username}
    Run Keyword If    '${i_password}'!='${EMPTY}'    Input Text    ${Form.SystemUser.Password.Txt}    ${i_password}
    Run Keyword If    '${i_password_confirmation}'!='${EMPTY}'    Input Text    ${Form.SystemUser.PasswordConfirmation.Txt}    ${i_password_confirmation}    

Form System User Verify Fields
    [Arguments]    ${i_username}=${EMPTY}
    Run Keyword If    '${i_username}'!='${EMPTY}'    Textfield Value Should Be    ${Form.SystemUser.Username.Txt}    ${i_username} 
      
Create System User
    [Arguments]    ${i_username}=${EMPTY}    ${i_password}=${EMPTY}    ${i_password_confirmation}=${EMPTY}
    GoTo Create System User Form
    Form System User Populate Fields    ${i_username}    ${i_password}    ${i_password_confirmation}
    Click Element    ${Form.Common.Confirm.Btn}

View System User
    [Arguments]    ${i_row}    ${i_username}
    GoTo View/Update/Delete System User Form    ${i_row}
    Form System User Verify Fields    ${i_username}
    Click Element    ${Form.Common.BackToList.Btn}

Update System User
    [Arguments]    ${i_row}    ${i_username}=${EMPTY}    ${i_password}=${EMPTY}    ${i_password_confirmation}=${EMPTY}
    GoTo View/Update/Delete System User Form    ${i_row}
    Form System User Populate Fields    ${i_username}    ${i_password}    ${i_password_confirmation}
    Click Element    ${Form.Common.Confirm.Btn}
    Page Should Contain Element    //h1[contains(text(),'System User List')]
    &{i_updated_row}    Create Dictionary    Username:=${i_username}
    View System User    ${i_updated_row}    ${i_username}
    
Delete System User
    [Arguments]    ${i_row}
    GoTo View/Update/Delete System User Form    ${i_row}
    Click Element    ${Form.Common.Delete.Btn}    
    Click Element    ${Page.DeleteConfirmation.YesImSure.Btn}    
    Page Should Contain Element    //h1[contains(text(),'System User List')]             

# Client Keywords
GoTo Create Client Form
    Click Element    ${Sidebar.StaticData.Clients.Link}
    Wait Until Element Is Visible    ${Sidebar.StaticData.NewClient.Link}    
    Click Element    ${Sidebar.StaticData.NewClient.Link}

GoTo Client List Page
    Click Element    ${Sidebar.StaticData.Clients.Link}
    Wait Until Element Is Visible    ${Sidebar.StaticData.ClientList.Link}    
    Click Element    ${Sidebar.StaticData.ClientList.Link} 

GoTo View/Update/Delete Client Form
    [Arguments]    ${i_row}
    GoTo Client List Page
    ${l_index}    Find Searched Row In The Table    ${Page.Common.ObjectListTable.Tbl}    ${i_row}
    Click Element    ${Page.Common.ObjectListTable.Tbl}/tbody/tr[${l_index}]/td[1]/a

Form Client Populate Fields
    [Arguments]    ${i_fname}=${EMPTY}    ${i_lname}=${EMPTY}    ${i_addr}=${EMPTY}    ${i_mobile}=${EMPTY}    ${i_email_addr}=${EMPTY}
    # Form Defaults
    Element Should Be Disabled    ${Form.Client.AccountNum.Txt}
    Element Should Be Disabled    ${Form.Client.Balance.Txt}    
    # Populate Actions
    Run Keyword If    '${i_fname}'!='${EMPTY}'    Input Text    ${Form.Client.FirstName.Txt}    ${i_fname}
    Run Keyword If    '${i_lname}'!='${EMPTY}'    Input Text    ${Form.Client.LastName.Txt}    ${i_lname}    
    Run Keyword If    '${i_addr}'!='${EMPTY}'    Input Text    ${Form.Client.Address.Txt}    ${i_addr}    
	Run Keyword If    '${i_mobile}'!='${EMPTY}'    Input Text    ${Form.Client.MobileNumber.Txt}    ${i_mobile}
	Run Keyword If    '${i_email_addr}'!='${EMPTY}'    Input Text    ${Form.Client.EmailAddress.Txt}    ${i_email_addr}

Form Client Verify Fields
    [Arguments]    ${i_fname}    ${i_lname}    ${i_addr}    ${i_mobile}    ${i_email_addr}
    # Form Defaults
    Element Should Be Disabled    ${Form.Client.AccountNum.Txt}
    Element Should Be Disabled    ${Form.Client.Balance.Txt}
    # Verify Actions
    Run Keyword If    '${i_fname}'!='${EMPTY}'    Textfield Value Should Be    ${Form.Client.FirstName.Txt}    ${i_fname}
    Run Keyword If    '${i_lname}'!='${EMPTY}'    Textfield Value Should Be    ${Form.Client.LastName.Txt}    ${i_lname}    
    Run Keyword If    '${i_addr}'!='${EMPTY}'    Textfield Value Should Be    ${Form.Client.Address.Txt}    ${i_addr}    
	Run Keyword If    '${i_mobile}'!='${EMPTY}'    Textfield Value Should Be    ${Form.Client.MobileNumber.Txt}    ${i_mobile}
	Run Keyword If    '${i_email_addr}'!='${EMPTY}'    Textfield Value Should Be    ${Form.Client.EmailAddress.Txt}    ${i_email_addr}
                   
Create Client
    [Arguments]    ${i_fname}    ${i_lname}    ${i_addr}    ${i_mobile}    ${i_email_addr}
    GoTo Create Client Form
    Form Client Populate Fields    ${i_fname}    ${i_lname}    ${i_addr}    ${i_mobile}    ${i_email_addr}
	Click Element    ${Form.Common.Confirm.Btn}

View Client
    [Arguments]    ${i_row}    ${i_fname}=${EMPTY}    ${i_lname}=${EMPTY}    ${i_addr}=${EMPTY}    ${i_mobile}=${EMPTY}    ${i_email_addr}=${EMPTY}
    GoTo View/Update/Delete Client Form    ${i_row}
    Form Client Verify Fields    ${i_fname}    ${i_lname}    ${i_addr}    ${i_mobile}    ${i_email_addr}
    Click Element    ${Form.Common.BackToList.Btn}    
    	
Update Client
    [Arguments]    ${i_row}    ${i_fname}=${EMPTY}    ${i_lname}=${EMPTY}    ${i_addr}=${EMPTY}    ${i_mobile}=${EMPTY}    ${i_email_addr}=${EMPTY}
    GoTo View/Update/Delete Client Form    ${i_row}
    Form Client Populate Fields    ${i_fname}    ${i_lname}    ${i_addr}    ${i_mobile}    ${i_email_addr}
	Click Element    ${Form.Common.Confirm.Btn}
	Page Should Contain Element    //h1[contains(text(),'Client List')]
    &{l_updated_row}    Create Dictionary
    ...    First Name:=${i_fname}
    ...    Last Name:=${i_lname}
    ...    Email Address:=${i_email_addr}
    View Client    ${l_updated_row}    i_fname=${i_fname}    i_lname=${i_lname}    i_addr=${i_addr}    i_mobile=${i_mobile}    i_email_addr=${i_email_addr}
	
Delete Client
    [Arguments]    ${i_row}    
    GoTo View/Update/Delete Client Form    ${i_row}    
    Click Element    ${Form.Common.Delete.Btn}    
    Click Element    ${Page.DeleteConfirmation.YesImSure.Btn}    
    Page Should Contain Element    //h1[contains(text(),'Client List')]
    
Get Client Balance
    [Arguments]    ${i_client_dict}
    &{row}    Create Dictionary    First Name:=Yuffie    Last Name:=Kisaragi
    ${l_row_index}    Find Searched Row In The Table    ${Page.Common.ObjectListTable.Tbl}    ${i_client_dict}
    &{l_header_dict}    Get Table Headers    ${Page.Common.ObjectListTable.Tbl}
    ${l_col_index}    Set Variable    &{l_header_dict}[Balance:]  
    ${l_balance}    Get Table Cell    ${Page.Common.ObjectListTable.Tbl}    ${l_row_index+1}    ${l_col_index}    # row index +1 because the table includes the header as a row  
    ${l_balance}    Convert To Number    ${l_balance}
    [Return]    ${l_balance}

# Deposit Transaction Keywords
GoTo Create Deposit Transaction Form
    Click Element    ${Sidebar.Transactions.Deposit.Link}    
    Wait Until Element Is Visible    ${Sidebar.Transactions.NewDeposit.Link}    
    Click Element    ${Sidebar.Transactions.NewDeposit.Link}

GoTo View Deposit Transaction Form
    Click Element    ${Sidebar.Transactions.Deposit.Link}    
    Wait Until Element Is Visible    ${Sidebar.Transactions.DepositTransactionList.Link}    
    Click Element    ${Sidebar.Transactions.DepositTransactionList.Link}

Form Deposit Transaction Populate Fields                 	
    [Arguments]    ${i_client}=${EMPTY}    ${i_amt}=${EMPTY}    
    # Form Defaults
    Element Should Be Disabled    ${Form.DepositTransaction.TrxDate.Txt}
    Element Should Be Disabled    ${Form.DepositTransaction.TrxRef.Txt}
    Element Should Be Disabled    ${Form.DepositTransaction.Status.Txt}
    Element Should Be Disabled    ${Form.DepositTransaction.Currency.Txt}
    # Populate Actions
    Run Keyword If    '${i_client}'!='${EMPTY}'    Select From List By Label    ${Form.DepositTransaction.Client.Cbo}    ${i_client}
    Run Keyword If    '${i_amt}'!='${EMPTY}'    Input Text    ${Form.DepositTransaction.DepositAmount.Txt}    ${i_amt}

Form Deposit Transaction Verify Fields
    [Arguments]    ${i_client}=${EMPTY}    ${i_amt}=${EMPTY}  
    # Form Defaults
    Element Should Be Disabled    ${Form.DepositTransaction.TrxDate.Txt}
    Element Should Be Disabled    ${Form.DepositTransaction.TrxRef.Txt}
    Element Should Be Disabled    ${Form.DepositTransaction.Status.Txt}
    Element Should Be Disabled    ${Form.DepositTransaction.Currency.Txt}
    Element Should Be Disabled    ${Form.DepositTransaction.Client.Cbo}
    Element Should Be Disabled    ${Form.DepositTransaction.DepositAmount.Txt}
    # Verify Actions
    Run Keyword If    '${i_client}'!='${EMPTY}'    List Selection Should Be    ${Form.DepositTransaction.Client.Cbo}    ${i_client}
    Run Keyword If    '${i_amt}'!='${EMPTY}'    Textfield Value Should Be    ${Form.DepositTransaction.DepositAmount.Txt}    ${i_amt}

Create Deposit Transaction
    [Arguments]    ${i_client}=${EMPTY}    ${i_amt}=${EMPTY}   
    GoTo Create Deposit Transaction Form
    Form Deposit Transaction Populate Fields    ${i_client}    ${i_amt}
    ${l_trx_ref}    Get Element Attribute    ${Form.DepositTransaction.TrxRef.Txt}    value
	Click Element    ${Form.Common.Confirm.Btn}
	[Return]    ${l_trx_ref}        

View Deposit Transaction
    [Arguments]    ${i_row}    ${i_client}=${EMPTY}    ${i_amt}=${EMPTY}  
    GoTo View Deposit Transaction Form
    ${l_index}    Find Searched Row In The Table    ${Page.Common.ObjectListTable.Tbl}    ${i_row}
    Click Element    ${Page.Common.ObjectListTable.Tbl}/tbody/tr[${l_index}]/td[1]/a
    Form Deposit Transaction Verify Fields    ${i_client}    ${i_amt}
    Click Element    ${Form.Common.BackToList.Btn}

# Withdraw Transaction Keywords
GoTo Create Withdraw Transaction Form
    Click Element    ${Sidebar.Transactions.Withdraw.Link}    
    Wait Until Element Is Visible    ${Sidebar.Transactions.NewWithdraw.Link}    
    Click Element    ${Sidebar.Transactions.NewWithdraw.Link}
    
GoTo View Withdraw Transaction Form 
    Click Element    ${Sidebar.Transactions.Withdraw.Link}    
    Wait Until Element Is Visible    ${Sidebar.Transactions.WithdrawTransactionList.Link}    
    Click Element    ${Sidebar.Transactions.WithdrawTransactionList.Link}

Form Withdraw Transaction Populate Fields
    [Arguments]    ${i_client}=${EMPTY}    ${i_amt}=${EMPTY}
    # Form Defaults
    Element Should Be Disabled    ${Form.WithdrawTransaction.TrxDate.Txt}
    Element Should Be Disabled    ${Form.WithdrawTransaction.TrxRef.Txt}
    Element Should Be Disabled    ${Form.WithdrawTransaction.Status.Txt}
    Element Should Be Disabled    ${Form.WithdrawTransaction.Currency.Txt}
    # Populate Actions
    Run Keyword If    '${i_client}'!='${EMPTY}'    Select From List By Label    ${Form.WithdrawTransaction.Client.Cbo}    ${i_client}
    Run Keyword If    '${i_amt}'!='${EMPTY}'    Input Text    ${Form.WithdrawTransaction.WithdrawAmount.Txt}    ${i_amt}    

Form Withdraw Transaction Verify Fields
    [Arguments]    ${i_client}=${EMPTY}    ${i_amt}=${EMPTY}
    # Form Defaults
    Element Should Be Disabled    ${Form.WithdrawTransaction.TrxDate.Txt}
    Element Should Be Disabled    ${Form.WithdrawTransaction.TrxRef.Txt}
    Element Should Be Disabled    ${Form.WithdrawTransaction.Status.Txt}
    Element Should Be Disabled    ${Form.WithdrawTransaction.Currency.Txt}
    Element Should Be Disabled    ${Form.WithdrawTransaction.Client.Cbo} 
    Element Should Be Disabled    ${Form.WithdrawTransaction.WithdrawAmount.Txt}         
    # Populate Actions
    Run Keyword If    '${i_client}'!='${EMPTY}'    List Selection Should Be    ${Form.WithdrawTransaction.Client.Cbo}    ${i_client}
    Run Keyword If    '${i_amt}'!='${EMPTY}'    Textfield Value Should Be    ${Form.WithdrawTransaction.WithdrawAmount.Txt}    ${i_amt}     
          
Create Withdraw Transaction
    [Arguments]    ${i_client}    ${i_amt} 
    GoTo Create Withdraw Transaction Form
    Form Withdraw Transaction Populate Fields    ${i_client}    ${i_amt}    
	${l_trx_ref}    Get Element Attribute    ${Form.WithdrawTransaction.TrxRef.Txt}    value
	Click Element    ${Form.Common.Confirm.Btn}
	[Return]    ${l_trx_ref}

View Withdraw Transaction
    [Arguments]    ${i_row}    ${i_client}    ${i_amt}
    GoTo View Withdraw Transaction Form
    ${l_index}    Find Searched Row In The Table    ${Page.Common.ObjectListTable.Tbl}    ${i_row}
    Click Element    ${Page.Common.ObjectListTable.Tbl}/tbody/tr[${l_index}]/td[1]/a
    Form Withdraw Transaction Verify Fields    ${i_client}    ${i_amt}
    Click Element    ${Form.Common.BackToList.Btn}

# Transfer Transaction Keyword
GoTo Create Transfer Transaction Form
    Click Element    ${Sidebar.Transactions.Transfer.Link}    
    Wait Until Element Is Visible    ${Sidebar.Transactions.NewTransfer.Link}    
    Click Element    ${Sidebar.Transactions.NewTransfer.Link}

GoTo View Transfer Transaction Form
    Click Element    ${Sidebar.Transactions.Transfer.Link}    
    Wait Until Element Is Visible    ${Sidebar.Transactions.TransferTransactionList.Link}    
    Click Element    ${Sidebar.Transactions.TransferTransactionList.Link}

Form Transfer Transaction Populate Fields
    [Arguments]    ${i_from_client}=${EMPTY}    ${i_to_client}=${EMPTY}    ${i_amt}=${EMPTY}
    # Form Defaults
    Element Should Be Disabled    ${Form.TransferTransaction.TrxDate.Txt}
    Element Should Be Disabled    ${Form.TransferTransaction.TrxRef.Txt}
    Element Should Be Disabled    ${Form.TransferTransaction.Status.Txt}
    Element Should Be Disabled    ${Form.TransferTransaction.Currency.Txt}
    # Populate Actions
    Select From List By Label    ${Form.TransferTransaction.FromClient.Cbo}    ${i_from_client}
    Select From List By Label    ${Form.TransferTransaction.ToClient.Cbo}    ${i_to_client}
    Input Text    ${Form.TransferTransaction.TransferAmount.Txt}    ${i_amt}
    
Form Transfer Transaction Verify Fields     	
    [Arguments]    ${i_from_client}=${EMPTY}    ${i_to_client}=${EMPTY}    ${i_amt}=${EMPTY}
    # Form Defaults
    Element Should Be Disabled    ${Form.TransferTransaction.TrxDate.Txt}
    Element Should Be Disabled    ${Form.TransferTransaction.TrxRef.Txt}
    Element Should Be Disabled    ${Form.TransferTransaction.Status.Txt}
    Element Should Be Disabled    ${Form.TransferTransaction.Currency.Txt}
    Element Should Be Disabled    ${Form.TransferTransaction.FromClient.Cbo}
    Element Should Be Disabled    ${Form.TransferTransaction.ToClient.Cbo}
    Element Should Be Disabled    ${Form.TransferTransaction.TransferAmount.Txt}    
    # Verify Actions
    List Selection Should Be    ${Form.TransferTransaction.FromClient.Cbo}    ${i_from_client}
    List Selection Should Be    ${Form.TransferTransaction.ToClient.Cbo}    ${i_to_client}
    Textfield Value Should Be    ${Form.TransferTransaction.TransferAmount.Txt}    ${i_amt}

Create Transfer Transaction
    [Arguments]    ${i_from_client}    ${i_to_client}    ${i_amt} 
    GoTo Create Transfer Transaction Form   
    Form Transfer Transaction Populate Fields    ${i_from_client}    ${i_to_client}    ${i_amt} 
	${l_trx_ref}    Get Element Attribute    ${Form.TransferTransaction.TrxRef.Txt}    value
	Click Element    ${Form.Common.Confirm.Btn}
	[Return]    ${l_trx_ref}

View Transfer Transaction
    [Arguments]    ${i_row}    ${i_from_client}    ${i_to_client}    ${i_amt}
    GoTo View Transfer Transaction Form
    ${l_index}    Find Searched Row In The Table    ${Page.Common.ObjectListTable.Tbl}    ${i_row}
    Click Element    ${Page.Common.ObjectListTable.Tbl}/tbody/tr[${l_index}]/td[1]/a
    Form Transfer Transaction Verify Fields    ${i_from_client}    ${i_to_client}    ${i_amt}
    Click Element    ${Form.Common.BackToList.Btn}  
    	
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


