*** Settings ***
Library         OperatingSystem
Library         Collections
Library         String
Library         CSVLibrary
Library         SeleniumLibrary
Variables       /Users/Godzi1la/Desktop/testcourse/robotcourses/product_data.yml  



*** Test Cases ***
Test Product Purchase

    #step 1 เปิดเว็บ และ login
    Open Browser To Base Url
    Login With Standard User

    #step 2 เลือกสินค้า
    Select Product 
    ${item_price} =    Get Text    xpath://div[@class='inventory_details_price']  
    Verify Back Button Class 
    Verify Product Added To Cart    ${product.p1.name}

    #step 3 ไปที่ Checkout
    Go To Checkout
    verify Cart and continue
    Enter Checkout Information   ${name.standard.fristname}   ${name.standard.lastname}   ${name.standard.zip}

    #step 4 เสร็จสิ้นการชำระเงิน
    Wait Until Element Is Visible    xpath://div[@class='summary_subtotal_label']    10s
    ${item_total_text} =    Get Text    xpath://div[@class='summary_subtotal_label']
    ${item_total} =    Evaluate    '${item_total_text}'.split('$')[1].strip() if '$' in '${item_total_text}' else '0'
    Should Be Equal As Numbers    ${item_price.replace('$', '')}    ${item_total}    
    Finish Checkout
    Verify Order Success Message    THANK YOU FOR YOUR ORDER
    
    #step 5 ปิด Browser
    Close Browser

*** Keywords ***

Open Browser To Base Url
    Open Browser    ${url}    ${browser}
    Wait Until Page Contains Element   xpath://input[@name='user-name']

Login With Standard User
    Input Text    id:user-name    ${name.standard.user}
    Input Text    id:password     ${name.standard.password}
    Click Button  id:login-button
    Wait Until Page Contains Element   //div[contains(text(),"Products")]

Select Product
    Click Element   //*[@id="item_4_title_link"]/div

Verify Back Button Class 
    Wait Until Element Is Visible    xpath://*[@id="inventory_item_container"]/div/button   10s
    Element Should Be Visible    xpath://*[@id="inventory_item_container"]/div/button     10s
    


Verify Product Added To Cart
    [Arguments]    ${product_name}
    Element Should Be Visible    xpath://div[text()='${product_name}']

Go To Checkout
    Click Button   //*[@id="inventory_item_container"]/div/div/div/button
    Wait Until Element Is Visible    xpath://a[@class='shopping_cart_link fa-layers fa-fw']   10s

verify Cart and continue   
    Click Element    xpath://a[@class='shopping_cart_link fa-layers fa-fw']
    Wait Until Element Is Visible    xpath://*[@id="contents_wrapper"]/div[2]   10s
    Element Should Be Visible    xpath://*[@id="contents_wrapper"]/div[2]
    Click Element    //*[@id="cart_contents_container"]/div/div[2]/a[2]

Enter Checkout Information
    Wait Until Element Is Visible    //*[@id="contents_wrapper"]/div[2]   10s
    Element Should Be Visible    //*[@id="contents_wrapper"]/div[2]
    [Arguments]    ${firstname}    ${lastname}    ${zip}
    Input Text     id:first-name    ${firstname}
    Input Text     id:last-name     ${lastname}
    Input Text     id:postal-code   ${zip}
    Click Button   //*[@id="checkout_info_container"]/div/form/div[2]/input

Finish Checkout
    Wait Until Element Is Visible    //*[@id="contents_wrapper"]/div[2]   10s
    Element Should Be Visible    //*[@id="contents_wrapper"]/div[2]
    Click Element   //*[@id="checkout_summary_container"]/div/div[2]/div[8]/a[2]

Verify Order Success Message
    [Arguments]    ${expected_message}
    Element Text Should Be   xpath://h2   ${expected_message}
