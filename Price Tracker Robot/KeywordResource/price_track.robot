*** Settings ***
Documentation       keywords

Library             RPA.Assistant
Library             RPA.FileSystem


*** Keywords ***
Create Csv File
    [Arguments]    ${FILE_PATH}
    ${status} =    Does File Exist    ${FILE_PATH}
    IF    ${status}==False    Create File    ${FILE_PATH}
