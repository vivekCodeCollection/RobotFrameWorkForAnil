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
     Sleep  3
     Execute JavaScript    window.scrollTo(0, 500)
     Sleep  2
     Mouse Over   ${Page.Product.ProDetail.Link}
     click button   ${Page.Product.AddToCart.Btn}
     @{args}    Create List    ${l_data['expectedTextInPage']}
     VERIFY    Page Should Contain    ${args}
     ${Price}   GetTotalPrice
     Log To Console   Price is ${Price}





GetTotalPrice
  ${orderPrice}   get text   ${SubTotalPrice}
  [Return]    ${orderPrice}


VerifyShippingAddres
   [Arguments]    ${Address}
   element should contain   ${ShippingAddress}      ${Address}



