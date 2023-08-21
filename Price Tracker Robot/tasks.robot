*** Settings ***
Documentation       Template robot main suite.

Library             RPA.Database
Library             RPA.Browser.Selenium
Library             String
Resource            KeywordResource/price_track.robot
Library             PythonLibrary/price_track.py


*** Variables ***
${product_url}          https://www.amazon.in/Dell-Gaming-i5-12500H-39-62cm-Backlit/dp/B0C918JGBM/ref=sxin_14_hcs-la-eu-tqprod?content-id=amzn1.sym.f274f612-64ae-41a9-a152-aa1f099eb86b%3Aamzn1.sym.f274f612-64ae-41a9-a152-aa1f099eb86b&cv_ct_cx=dell%2Blaptops&keywords=dell%2Blaptops&pd_rd_i=B0C918JGBM&pd_rd_r=861a0fb0-8560-4c4c-950f-18588bec2746&pd_rd_w=vgtnb&pd_rd_wg=7f26w&pf_rd_p=f274f612-64ae-41a9-a152-aa1f099eb86b&pf_rd_r=521SF5PNYDJJ2JXYXCRM&qid=1692525868&sbo=RZvfv%2F%2FHxDF%2BO5021pAnSA%3D%3D&sr=1-1-ca1238e8-4946-4218-b362-7c3431ea8df6&th=1
${threshold_price}      70000    # Set your desired price threshold


*** Tasks ***
# Track Product Price
#    Open Available Browser    ${product_url}
#    ${name_of_product} =    Get Text    locator=//*[@id="title"]
#    ${name_of_product} =    Replace String    ${name_of_product}    ,    ${EMPTY}    count=-1
#    ${current_price} =    Get Text
#    ...    locator=//*[@id="corePriceDisplay_desktop_feature_div"]/div[1]/span[2]/span[2]/span[2]
#    Close Browser
#    TRY
#    Convert To Number    ${current_price}
#    EXCEPT
#    ${current_price} =    Replace String    ${current_price}    ,    ${EMPTY}
#    # Log    ${current_price}
#    Convert To Number    ${current_price}
#    END

#    Convert To Number    ${threshold_price}

#    IF    ${current_price} < ${threshold_price}
#    Log    Price Drop    level=WARN
#    Price Drop Notification
#    END
#    Create Csv File    ./prices.csv
#    Append To The Csv    ./prices.csv    ${name_of_product}    ${current_price}

Writing Data To Database
    Write To Database

Reading data from Database
    # Connect to a local SQLite3 DB saved locally as "stores.db".
    Connect To Database    sqlite3    stores.db    autocommit=${True}

    # retrieving data
    @{price_list} =    Query    SELECT * FROM prices
    Log    message=@{price_list}    formatter=repr
