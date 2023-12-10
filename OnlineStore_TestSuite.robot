*** Settings ***
Test Setup        Open Browser    https://academybugs.com/find-bugs/    Chrome
Test Teardown     Close Browser
Library           SeleniumLibrary
Library           String
Library           BuiltIn

*** Variables ***

*** Test Cases ***
Price_Check_Listing_Product
    [Documentation]    Validate consistency of first product's price across listing and detail page
    ${Price1}=    Get Text    //*[@id="ec_product_image_4481370"]/div[3]/div[1]/span    #Obtains the price of the first product display
    Click Element    //*[@id="ec_product_image_effect_4481370"]    \    #Click on first product
    ${Price2}=    Get Text    //*[@id="post-1675"]/div/section/div[1]/div[3]/form/div[2]/span    #Obtains the price of the same product on detail page
    ${Price1}=    Remove String    ${Price1}    $    #Remove currency
    ${Price2}=    Remove String    ${Price2}    $    #Remove curreny
    Should be equal    ${Price1}    ${Price2}    #Validate that both prices are equal

Set_ModelNumber_SuiteVar
    [Documentation]    Extract and assign numbers from model number as suite variable
    Click Element    //*[@id="ec_product_image_effect_3981370"]    #Clic on selected product
    ${ModelNum}=    Get Text    //*[@id="post-6190"]/div/section/div[1]/div[3]/form/div[3]    #Gets model of product
    ${ModelNum}=    Remove String    ${ModelNum}    Model Number: \    #Deletes ''Model Number: '' from the obtained value
    Set Suite Variable    ${ModelNum}    #Model number assigned as suite variable

ModelNum_Search_Result_Displayed
    [Documentation]    Verify display of searched product on search page
    Click Element    //*[@id="ec_product_image_effect_3981370"]    #Click on a product image
    Input Text    //*[@id="ec_searchwidget-3"]/div/form/input[1]    ${ModelNum}    #Enters model number into search field
    Click Button    //*[@id="ec_searchwidget-3"]/div/form/input[2]    #Click on search button

Price_Sorting_LowestPrice_Check
    [Documentation]    Validate 'Searching by price' feature on product listing and verify the smallest value of the first listed product
    Select From List by index    //*[@id="sortfield"]    1    #Select sorting option by index
    ${Price1}=    Get Text    //*[@id="ec_product_image_4881370"]/div[3]/div[1]/span    #Get first price value
    ${Price1}=    Remove String    ${Price1}    $    #Remove currency
    ${prices}    Get WebElements    //*[@id="ec_store_product_list"]    #Get all product prices
    ${Price1}    Convert To Number    ${Price1}    #Convert price to number
    FOR    ${element}    IN    @{prices}    #Iterates through each price
        ${price_text}    Get Text    ${element}    #Get text of each element
        ${numbers}    Get Regexp Matches    ${price_text}    \\d+\\.\\d+|\\d+    #Gets numbers
        FOR    ${num}    IN    @{numbers}    #Iterates though all numbers
            ${float_num}    Convert To Number    ${num}    #Change to a num
            ${result}    Run Keyword AND Return Status    Should be True    ${Price1}<=${float_num}    #Compares price
            Run Keyword IF    ${Price1}>${float_num}    Fail    ${Price1}>${float_num}    #Fails if comparison is false
        END
        END
