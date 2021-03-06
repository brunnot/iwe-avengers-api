Feature: Perform integrated tests on the Avengers registration API

Background:
* url 'https://hqargrkoc4.execute-api.us-east-1.amazonaws.com/dev'

* def getToken =
"""
function() {
 var TokenGenerator = Java.type('com.iwe.avengers.test.authorization.TokenGenerator');
 var sg = new TokenGenerator();
 return sg.getToken();
}
"""
* def token = call getToken

Scenario: Should retur a non-authorization access
Given path "avengers"
And request {name: 'Iron Man', secretIndentify: 'Tony Stark'}
When method post
Then status 401


Scenario: Should return not found Avenger
Given path 'avengers','no-found-id'
And header Authorization = 'Bearer ' + token
When method get
Then status 404

Scenario: Create Avenger
Given path 'avengers'
And header Authorization = 'Bearer ' + token
And request {name: 'Iron Man', secretIdentity: 'Tony Stark'}
When method post
Then status 201
And match response == {id: '#string', name: 'Iron Man', secretIdentity: 'Tony Stark'}

* def savedAvenger = response

Given path 'avengers', savedAvenger.id
And header Authorization = 'Bearer ' + token
When method get
Then status 200
And match response == savedAvenger


Scenario: Must return 400 for invalid creation payload
And header Authorization = 'Bearer ' + token
Given path 'avengers'
And request {secretIdentity: 'Tony Stark'}
When method post
Then status 400


Scenario: Update avengers
And header Authorization = 'Bearer ' + token
Given path 'avengers'
And request {name: 'Iron', secretIdentity: 'Tony'}
When method post
Then status 201
And match response == {id: '#string', name: 'Iron', secretIdentity: 'Tony'}

* def savedAvenger = response

Given path 'avengers', savedAvenger.id
And header Authorization = 'Bearer ' + token
And request {name: 'Iron Man', secretIdentity: 'Tony Stark'}
When method put
Then status 200
And match response ==  {id: '#string', name: 'Iron Man', secretIdentity: 'Tony Stark'}



Scenario: Must return 400 for invalid update payload
Given path 'avengers','aaaa-bbbb-cccc-dddd'
And header Authorization = 'Bearer ' + token
And request {secretIdentity: 'Tony Stark'}
When method put
Then status 400

Scenario: Update avengers 404
Given path 'avengers','aaaa-bbbb-ccccdddd'
And header Authorization = 'Bearer ' + token
And request {name: 'Iron Man', secretIdentity: 'Tony Stark'}
When method put
Then status 404


Scenario: Delete avengers by id

Given path 'avengers'
And header Authorization = 'Bearer ' + token
And request {name: 'Iron Man', secretIdentity: 'Tony Stark'}
When method post
Then status 201
And match response == {id: '#string', name: 'Iron Man', secretIdentity: 'Tony Stark'}

* def savedAvenger = response

Given path 'avengers',savedAvenger.id
And header Authorization = 'Bearer ' + token
When method delete
Then status 204

Given path 'avengers', savedAvenger.id
And header Authorization = 'Bearer ' + token
When method get
Then status 404

Scenario: Delete avengers by id return 404
And header Authorization = 'Bearer ' + token
Given path 'avengers','dddd'
When method delete
Then status 404