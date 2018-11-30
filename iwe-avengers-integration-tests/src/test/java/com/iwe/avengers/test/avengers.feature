Feature: Perform integrated tests on the Avengers registration API

Background:
* url 'https://hqargrkoc4.execute-api.us-east-1.amazonaws.com/dev'

Scenario: Should return not found Avenger
Given path 'avengers','no-found-id'
When method get
Then status 404

Scenario: Create Avenger
Given path 'avengers'
And request {name: 'Iron Man', secretIdentity: 'Tony Stark'}
When method post
Then status 201
And match response == {id: '#string', name: 'Iron Man', secretIdentity: 'Tony Stark'}

* def savedAvenger = response

Given path 'avengers', savedAvenger.id
When method get
Then status 200
And match response == savedAvenger


Scenario: Must return 400 for invalid creation payload
Given path 'avengers'
And request {secretIdentity: 'Tony Stark'}
When method post
Then status 400


Scenario: Update avengers
Given path 'avengers'
And request {name: 'Iron', secretIdentity: 'Tony'}
When method post
Then status 201
And match response == {id: '#string', name: 'Iron', secretIdentity: 'Tony'}

* def savedAvenger = response

Given path 'avengers', savedAvenger.id
And request {name: 'Iron Man', secretIdentity: 'Tony Stark'}
When method put
Then status 200
And match response ==  {id: '#string', name: 'Iron Man', secretIdentity: 'Tony Stark'}



Scenario: Must return 400 for invalid update payload
Given path 'avengers','aaaa-bbbb-cccc-dddd'
And request {secretIdentity: 'Tony Stark'}
When method put
Then status 400

Scenario: Update avengers 404
Given path 'avengers','aaaa-bbbb-ccccdddd'
And request {name: 'Iron Man', secretIdentity: 'Tony Stark'}
When method put
Then status 404


Scenario: Delete avengers by id

Given path 'avengers'
And request {name: 'Iron Man', secretIdentity: 'Tony Stark'}
When method post
Then status 201
And match response == {id: '#string', name: 'Iron Man', secretIdentity: 'Tony Stark'}

* def savedAvenger = response

Given path 'avengers',savedAvenger.id
When method delete
Then status 204

Given path 'avengers', savedAvenger.id
When method get
Then status 404

Scenario: Delete avengers by id return 404
Given path 'avengers','dddd'
When method delete
Then status 404


Scenario: Should return invalid access
Given path 'avengers', 'any-id'
When method get
Then status 401

