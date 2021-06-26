*** Settings ***
Resource    ../../resources/keywords.robot

*** Variables ***
${FirstPart}   (//span[contains(text(),xpath)])[1]
${Replacable}   xpath

*** Keywords ***
Products Template
     [Arguments]    ${i_data}
     ${l_data}    Load Json Data Into Dictionary    ${i_data}
     Sleep  2
     Mouse Over      xpath=(//span[contains(text(),'${l_data['ProductCategory']['input']}')])[1]
     click element   xpath=//span[normalize-space()='${l_data['ProductName']['input']}']
     #scroll element into view   ${Page.Product.ProDetail.Link}
     Sleep  3
     Execute JavaScript    window.scrollTo(0, 500)
     Sleep  2
     Mouse Over   ${Page.Product.ProDetail.Link}
     click button   ${Page.Product.AddToCart.Btn}
     @{args}    Create List    ${l_data['expectedTextInPage']}
     VERIFY    Page Should Contain    ${args}



