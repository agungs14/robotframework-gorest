*** Settings ***
Library           Selenium2Library
Library           HttpLibrary.HTTP
Library           RequestsLibrary
Library           FakerLibrary
Library           String

*** Variables ***
${URL_GOREST}       https://gorest.co.in/
${ACCESS_TOKEN}     %{GOREST_ACCESS_TOKEN}   #This is a environtment variable access token. insert value your access token gorest, to your local environtment variables

*** Keywords ***
generate email
    Log    >>> generating random email
    ### generate fakers
    ${fake_name}=    FakerLibrary.First Name
    ${fake_name_lower}=    Convert To Lowercase    ${fake_name}
    ${randomNumber}=    FakerLibrary.Numerify    text=###
    ### generate dummy email
    ${email_prefix}=    Set Variable    apitest+
    ${email_suffix}=    Set Variable    @forest.id
    ${email}=    Catenate    ${email_prefix}${fake_name_lower}${randomNumber}${email_suffix}
    Return From Keyword    ${email}


*** Test Cases *** 
Post create users gorest
    [Tags]    1
    #Generate random email
    ${email}=   generate email
    Log To Console    >>> email random: ${email}
    Log To Console    >>> Hit create users gorest with email: ${email}
    ##preparing body
    ${body}=    Set Variable    { \ \ "name": "Bianca Haliza", \ \ "gender": "Male", \ \ "email": "${email}", \ \ "status": "Active" }
    Log To Console    >>> request body: ${body}
    ### prepare header
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${ACCESS_TOKEN}
    ### hit create user
    Create Session    session    ${URL_GOREST}
    ${result}=    Post Request    session    /public-api/users    data=${body}    headers=${headers}
    ### parse response and get users id
    Log To Console    >>> response: ${result.content}
    Log To Console    >>> response: ${result.headers}
    Log To Console    >>> response: ${result.status_code}
    ${responseJson}=    Set Variable    ${result.content}
    ${responseid}=    Get Json Value    ${responseJson}    /data/id
    Log To Console    >>> ID users: ${responseid}
    Set Global Variable    ${responseid}

Get user detail gorest by id
    [Tags]    2
    Log To Console    >>>start to hit gorest user details id: ${responseid}
    #URL GET User List
    Create Session    myssion    ${URL_GOREST}/public-api/users/${responseid}
    #Request Headers
    ${headers}    create dictionary    Authorization=Bearer ${ACCESS_TOKEN}    Content-Type=application/json
    #Response
    ${response}=    Get Request    myssion    /    headers=${headers}
    Log To Console    >>>${response.status_code}
    Log To Console    >>>${response.content}
    Log To Console    >>>${response.headers}
    Log To Console    >>>Success get user details id: ${responseid}

Update user detail gorest
    [Tags]    3
    #set var new name & status
    ${newname}=    Set Variable    Wirtz Julian
    ${status}=  Set Variable    Inactive
    #Generate random email to update email
    ${newemail}=   generate email
    Log To Console    >>> email new random: ${newemail}
    Log To Console    >>> Hit create users gorest with email: ${newemail}
    ##preparing body
    ${body}=    Set Variable    { \ \ "name": "${newname}", \ \ "gender": "Male", \ \ "email": "${newemail}", \ \ "status": "${status}" }
    Log To Console    >>> request body: ${body}
    ### prepare header
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${ACCESS_TOKEN}
    ### hit
    Create Session    session    ${URL_GOREST}
    ${result}=    Put Request    session    /public-api/users/${responseid}    data=${body}    headers=${headers}
    ### parse response and get users id, name, email, status
    Log To Console    >>> response: ${result.content}
    Log To Console    >>> response: ${result.headers}
    Log To Console    >>> response: ${result.status_code}
    ${responseJson}=    Set Variable    ${result.content}
    ${responseid}=    Get Json Value    ${responseJson}    /data/id
    ${responsename}=    Get Json Value    ${responseJson}    /data/name
    ${responsename}=    Evaluate    '${responsename}'.replace('"','')       #convert "name" >> name
    ${responseemail}=    Get Json Value    ${responseJson}    /data/email
    ${responseemail}=    Evaluate    '${responseemail}'.replace('"','')
    ${responsestatus}=    Get Json Value    ${responseJson}    /data/status
    ${responsestatus}=    Evaluate    '${responsestatus}'.replace('"','')
    Log To Console      >>> new update= name: ${responsename}, email: ${responseemail}   status: ${responsestatus}
    #Validate new update
    Should Be Equal As Strings   ${newname}      ${responsename}     #validate newname
    Should Be Equal As Strings   ${newemail}      ${responseemail}     #validate newemail
    Should Be Equal As Strings   ${status}      ${responsestatus}     #validate newnemail

Delete user gorest
    [Tags]    4
    Log To Console    >>>start to delete gorest user details id: ${responseid}
    #URL Delete User List
    Create Session    myssion    ${URL_GOREST}/public-api/users/${responseid}
    #Request Headers
    ${headers}    create dictionary    Authorization=Bearer ${ACCESS_TOKEN}    Content-Type=application/json
    #Response
    ${response}=    Delete Request    myssion    /    headers=${headers}
    Log To Console    >>>${response.status_code}
    Log To Console    >>>${response.content}
    Log To Console    >>>${response.headers}
    Log To Console    >>>Success delete user id: ${responseid}
    #Check data=null
    ${responseJson}=    Set Variable    ${response.content}
    ${response_id_deleted}=    Get Json Value    ${responseJson}    /data
    Log To Console    >>>data id ${responseid}=${response_id_deleted}

Create User failed - Request header no Authorization
    [Tags]    5
    #Generate random email
    ${email}=   generate email
    Log To Console    >>> email random: ${email}
    Log To Console    >>> Hit create users gorest with email: ${email}
    ##preparing body
    ${body}=    Set Variable    { \ \ "name": "Bianca Haliza", \ \ "gender": "Male", \ \ "email": "${email}", \ \ "status": "Active" }
    Log To Console    >>> request body: ${body}
    ### prepare header no authorization
    ${headers}=    Create Dictionary    Content-Type=application/json    #Authorization=Bearer ${ACCESS_TOKEN}
    ### hit create user
    Create Session    session    ${URL_GOREST}
    ${result}=    Post Request    session    /public-api/users    data=${body}    headers=${headers}
    ### parse response and get users id
    Log To Console    >>> response: ${result.content}
    Log To Console    >>> response: ${result.headers}
    Log To Console    >>> response: ${result.status_code}
    ${responseJson}=    Set Variable    ${result.content}
    ${responsecode}=    Get Json Value    ${responseJson}    /code
    ### Validate auth failed code: 401
    Should Be Equal As Strings      ${responsecode}       401

Create User failed - Blank request body
    [Tags]    6
    #Generate random email
    ${email}=   generate email
    Log To Console    >>> email random: ${email}
    Log To Console    >>> Hit create users gorest with email: ${email}
    ##preparing body
    #${body}=    Set Variable    { \ \ "name": "Bianca Haliza", \ \ "gender": "Male", \ \ "email": "${email}", \ \ "status": "Active" }
    #Log To Console    >>> request body: ${body}
    ### prepare header no authorization
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${ACCESS_TOKEN}
    ### hit create user
    Create Session    session    ${URL_GOREST}
    ${result}=    Post Request    session    /public-api/users    headers=${headers}
    ### parse response and get users id
    Log To Console    >>> response: ${result.content}
    Log To Console    >>> response: ${result.headers}
    Log To Console    >>> response: ${result.status_code}
    ${responseJson}=    Set Variable    ${result.content}
    ${responsecode}=    Get Json Value    ${responseJson}    /code
    ### Validate auth failed code: 422
    Should Be Equal As Strings      ${responsecode}       422

Create User failed - email has already been taken
    [Tags]    7
    #Set Email Already taken
    ${emailalreadytaken}=   Set Variable    kaihavertz@shopoyi.id
    Log To Console    >>> email random: ${emailalreadytaken}
    Log To Console    >>> Hit create users gorest with email: ${emailalreadytaken}
    ##preparing body - input email already taken
    ${body}=    Set Variable    { \ \ "name": "test nama", \ \ "gender": "Male", \ \ "email": "${emailalreadytaken}", \ \ "status": "Active" }
    Log To Console    >>> request body: ${body}
    ### prepare header no authorization
    ${headers}=    Create Dictionary    Content-Type=application/json       Authorization=Bearer ${ACCESS_TOKEN}
    ### hit create user
    Create Session    session    ${URL_GOREST}
    ${result}=    Post Request    session    /public-api/users    data=${body}      headers=${headers}
    ### parse response and get users id
    Log To Console    >>> response: ${result.content}
    Log To Console    >>> response: ${result.headers}
    Log To Console    >>> response: ${result.status_code}
    ${responseJson}=    Set Variable    ${result.content}
    ${responsecode}=    Get Json Value    ${responseJson}    /code
    ### Validate auth failed code: 422
    Should Be Equal As Strings      ${responsecode}       422

Create User failed - error when entering a value status: Disable
    [Tags]    8
    #Generate random email
    ${email}=   generate email
    Log To Console    >>> email random: ${email}
    Log To Console    >>> Hit create users gorest with email: ${email}
    ##preparing body - Input value "status: Disable"
    ${body}=    Set Variable    { \ \ "name": "Bianca Haliza", \ \ "gender": "Male", \ \ "email": "${email}", \ \ "status": "Disable" }
    #Log To Console    >>> request body: ${body}
    ### prepare header no authorization
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${ACCESS_TOKEN}
    ### hit create user
    Create Session    session    ${URL_GOREST}
    ${result}=    Post Request    session    /public-api/users    data=${body}      headers=${headers}
    ### parse response and get users id
    Log To Console    >>> response: ${result.content}
    Log To Console    >>> response: ${result.headers}
    Log To Console    >>> response: ${result.status_code}
    ${responseJson}=    Set Variable    ${result.content}
    ${responsecode}=    Get Json Value    ${responseJson}    /code
    ### Validate auth failed code: 422
    Should Be Equal As Strings      ${responsecode}       422

Create User failed - error when entering a value gender: MAN
    [Tags]    9
    #Generate random email
    ${email}=   generate email
    Log To Console    >>> email random: ${email}
    Log To Console    >>> Hit create users gorest with email: ${email}
    ##preparing body - Input value "gender: MAN"
    ${body}=    Set Variable    { \ \ "name": "Bianca Haliza", \ \ "gender": "MAN", \ \ "email": "${email}", \ \ "status": "Active" }
    #Log To Console    >>> request body: ${body}
    ### prepare header no authorization
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${ACCESS_TOKEN}
    ### hit create user
    Create Session    session    ${URL_GOREST}
    ${result}=    Post Request    session    /public-api/users    data=${body}      headers=${headers}
    ### parse response and get users id
    Log To Console    >>> response: ${result.content}
    Log To Console    >>> response: ${result.headers}
    Log To Console    >>> response: ${result.status_code}
    ${responseJson}=    Set Variable    ${result.content}
    ${responsecode}=    Get Json Value    ${responseJson}    /code
    ### Validate auth failed code: 422
    Should Be Equal As Strings      ${responsecode}       422

Get user detail - Get ALL User
    [Tags]    10
    Log To Console    >>>start to hit gorest all users
    #URL GET User List
    Create Session    myssion    ${URL_GOREST}/public-api/users
    #Request Headers
    ${headers}    create dictionary    Authorization=Bearer ${ACCESS_TOKEN}    Content-Type=application/json
    #Response
    ${response}=    Get Request    myssion    /    headers=${headers}
    Log To Console    >>>${response.status_code}
    Log To Console    >>>${response.content}
    Log To Console    >>>${response.headers}
    Log To Console    >>>Success get all users detail
