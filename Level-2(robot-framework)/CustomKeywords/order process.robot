*** Settings ***
Documentation       Whole order process

Library             RPA.Browser.Selenium
Library             RPA.HTTP
Library             RPA.Tables
Library             RPA.PDF


*** Keywords ***
Open the robot order website
    Open Available Browser    url=https://robotsparebinindustries.com/#/robot-order    maximized=True

Get orders
    Download    url=https://robotsparebinindustries.com/orders.csv    overwrite=${True}
    ${table}=    Read table from CSV    path=orders.csv
    RETURN    ${table}

Loop over a list of items in table and log each of them
    [Arguments]    ${v}
    FOR    ${i}    IN    @{v}
        Log    ${i}
    END

    # ${rows}    ${columns}=    Get table dimensions    ${v}
    # FOR    ${i}    IN RANGE    ${rows}
    #    ${r}=    Get table row    ${v}    ${i}
    #    Log    ${r}
    # END

Fill the Form
    [Arguments]    ${v}
    FOR    ${i}    IN    @{v}
        Click Button When Visible    locator=//*[@id="root"]/div/div[2]/div/div/div/div/div/button[1]
        Select From List By Value    //*[@id="head"]    ${i}[Head]
        Input Text    locator=//*[@id="address"]    text=${i}[Address]
        ${v}=    Set Variable    ${i}[Body]
        IF    ${v} == 1    Click Button    //*[@id="id-body-1"]
        IF    ${v} == 2    Click Button    //*[@id="id-body-2"]
        IF    ${v} == 3    Click Button    //*[@id="id-body-3"]
        IF    ${v} == 4    Click Button    //*[@id="id-body-4"]
        IF    ${v} == 5    Click Button    //*[@id="id-body-5"]
        IF    ${v} == 6    Click Button    //*[@id="id-body-6"]
        Input Text    locator=//*[starts-with(@id,'16910')]    text=${i}[Legs]
        ${orderid}=    Set Variable    ${i}[Order number]
        Click Button    //*[@id="preview"]
        Screenshot    locator=//*[@id="robot-preview-image"]    filename=${OUTPUT_DIR}//screenshots//${orderid}.png
        # Retry three times at half-second intervals.
        Wait Until Keyword Succeeds    5 min    10 sec    Click Button    locator=//*[@id="order"]
        # Xpath=//*[contains(@name,'btn')
        TRY
            merge pdf    ${orderid}
            Click Button When Visible    locator=//*[@id="order-another"]
        EXCEPT
            Wait Until Keyword Succeeds    10 min    10 sec    Click Button    locator=//*[@id="order"]
            TRY
                merge pdf    ${orderid}
                Click Button When Visible    locator=//*[@id="order-another"]
            EXCEPT
                Wait Until Keyword Succeeds    15 min    10 sec    Click Button    locator=//*[@id="order"]
                TRY
                    merge pdf    ${orderid}
                    Click Button When Visible    locator=//*[@id="order-another"]
                EXCEPT
                    Wait Until Keyword Succeeds    20 min    10 sec    Click Button    locator=//*[@id="order"]
                    TRY
                        merge pdf    ${orderid}
                        Click Button When Visible    locator=//*[@id="order-another"]
                    EXCEPT
                        Wait Until Keyword Succeeds    25 min    10 sec    Click Button    locator=//*[@id="order"]
                        merge pdf    ${orderid}
                        Click Button When Visible    locator=//*[@id="order-another"]
                    END
                END
            END
        END
    END

# pdf
#    Click Button    locator=//*[@id="root"]/div/div[2]/div/div/div/div/div/button[1]
#    Select From List By Value    //*[@id="head"]    1
#    Input Text    locator=//*[@id="address"]    text=prashu
#    ${v}=    Set Variable    1
#    IF    ${v} == 1    Click Button    //*[@id="id-body-1"]
#    IF    ${v} == 2    Click Button    //*[@id="id-body-2"]
#    IF    ${v} == 3    Click Button    //*[@id="id-body-3"]
#    IF    ${v} == 4    Click Button    //*[@id="id-body-4"]
#    IF    ${v} == 5    Click Button    //*[@id="id-body-5"]
#    IF    ${v} == 6    Click Button    //*[@id="id-body-6"]
#    Input Text    locator=//*[starts-with(@id,'16909')]    text=2
#    ${orderid}=    Set Variable    1
#    Click Button    //*[@id="preview"]
#    Screenshot    locator=//*[@id="robot-preview-image"]    filename=${OUTPUT_DIR}//screenshots//${orderid}.png
#    # Retry three times at half-second intervals.
#    Wait Until Keyword Succeeds    15 min    10 sec    Click Button    locator=//*[@id="order"]
#    ${receipt_html}=    Get Element Attribute    locator=//*[@id="receipt"]    attribute=outerHTML
#    Html To Pdf    content=${receipt_html}    output_path=${OUTPUT_DIR}//receipts//${orderid}.Pdf
#    Click Button When Visible    locator=//*[@id="order-another"]
#    ${files}=    Create List
#    ...    output//screenshots//${orderid}.png:y=10,x=10
#    ...    output//receipts//${orderid}.Pdf
#    Add Files To PDF    ${files}    output//a_pdfs//${orderid}.Pdf

merge pdf
    [Arguments]    ${orderid}
    ${receipt_html}=    Get Element Attribute    locator=//*[@id="receipt"]    attribute=outerHTML
    Html To Pdf    content=${receipt_html}    output_path=${OUTPUT_DIR}//receipts//${orderid}.Pdf
    Click Button When Visible    locator=//*[@id="order-another"]
    ${files}=    Create List
    ...    output//screenshots//${orderid}.png:y=10,x=10
    ...    output//receipts//${orderid}.Pdf
    Add Files To PDF    ${files}    output//a_pdfs//${orderid}.Pdf
