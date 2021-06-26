*** Variables ***
# Login Page
${Page.Login.Username.Txt}    id=email
${Page.Login.Password.Txt}    id=pass
${Page.primary.Login.Btn}     xpath=//a[@class='action primary']
${Page.Account.Login.Btn}     xpath=//button[@class='action switch' and @data-action='guest-menu-toggle']
${Page.Login.Login.Btn}       css=button#send2
${Page.Login.UserInputBox.ErrorMsg}  id=email-error
${Page.Login.PwdInputBox.ErrorMsg}   id=pass-error

# Registration
${Page.Registration.CreateAnAcount.Link}     xpath=//a[@class='action' and @title='Create an Account']
${Page.Registration.FirstName.Input}   id=firstname
${Page.Registration.LastName.Input}    id=lastname
${Page.Registration.Email.Input}       id=email_address
${Page.Registration.Password.Input}    id=password
${Page.Registration.ConfirmPassword.Input}    id=password-confirmation
${Page.Registration.RemeberMe.Chkbox}     id=remember-me-box
${Page.Registration.CreateAccount.Btn}    xpath=//button[@class='action submit primary' and @type='submit']

#AddToCart
${Page.Product.ProDetail.Link}   xpath=(//ol[@class='products list items product-items']/li)[1]
${Page.Product.AddToCart.Btn}   xpath=(//button[@title='Add to Cart'])[1]
${SubTotalPrice}           xpath=//td[@data-th='Grand Total']//span
${CheckOutBtn}             xapth=//button[@title='Checkout']/span
${ShippingAddress}   xpath=(//address[@class='addressLabel-root-jdd'])[1]
${NextDeliveryMetod}   xpath=(//button/span[text()='Next: Delivery Method'])[1]
${ThresholdDelivery}   xpath=//span[text()='Threshold Delivery']
${NextPaymentMethod}   xpath=(//span[text()='Next: Payment Method'])[1]
${Affirm_PaymentOption}   xpath=(//span[text()='Affirm'])[1]
${AgreeChkBox}   id=agreement_id_2-formItem-id
${PayInFull}  xpath=//span[text()='Pay in Full']
${NextReviewAndSubmit}  xpath=//div[text()='Payment Amount Options']/..//button/span[text()='Next: Review & Submit']
${PlaceYourOrder}   xpath=//button//span[text()='Place Your Order']

# Top Bar Profile
${Topbar.Profile.ProfileIcon.Link}    xpath=//div[@class='customer-action']//button[@type='button']
${Topbar.Profile.ProfileLink.Link}    xpath=//a[@id='profile']
${Topbar.Profile.Logout.Link}    xpath=//div[@class='customer-menu']//a[contains(text(),'Sign Out')]

# Popup - Ready To Leave
${Popup.ReadyToLeave.Logout.Btn}    xpath=//a[text()='Logout']

