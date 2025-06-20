@MarvelCharacters
Feature: Test de API súper simple

    Background:
      * configure ssl = true
#      It's necessary in each "run test" change the {username} to start the id_character in "1". andemar201, andemar202, etc.
      * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/andemar201/api'
      * def id_character = 1
      * def id_not_found = 999

    @id:4 @CreateCharacter
    Scenario Outline: Verify creation of character (200)
      * def body = read('classpath:../data/create-character.json')
      * header Content-Type = 'application/json'
      Given path 'characters'
      And request body
      When method post
      * print body
      Then status 201
      * print response
      And match response.name == '<name>'

      Examples:
        | read('classpath:../data/data.csv') |

    @id:1 @GetCharacters
    Scenario: Verify get of characters (200)
      Given path 'characters'
      When method get
      Then status 200

    @id:2 @GetCharactersById
    Scenario: Verify get by id of character (200)
      Given path 'characters', id_character
      When method get
      Then status 200

    @id:3 @GetCharactersNotFound
    Scenario: Verify not found character (404)
      Given path 'characters', id_not_found
      When method get
      Then status 404

    @id:5 @CreateDuplicateCharacterError
    Scenario: Verify character duplication (400)
      * def body = read('classpath:../data/duplicate-character.json')
      * header Content-Type = 'application/json'
      Given path 'characters'
      And request body
      When method post
      * print body
      Then status 400
      * print response
      And match response.error == 'Character name already exists'

    @id:6 @CreateEmptyFieldsCharacterError
    Scenario: Verify character duplication (400)
      * def body = read('classpath:../data/empty-fields-character.json')
      * header Content-Type = 'application/json'
      Given path 'characters'
      And request body
      When method post
      * print body
      Then status 400
      * print response
      And match response.name == 'Name is required'
      And match response.description == 'Description is required'
      And match response.powers == 'Powers are required'
      And match response.alterego == 'Alterego is required'

    @id:7 @UpdateCharacter
    Scenario Outline: Verify character update (200)
      * def body = read('classpath:../data/update-character.json')
      * header Content-Type = 'application/json'
      Given path 'characters', id_character
      And request body
      When method put
      * print body
      Then status 200
      * print response
      And match response.description == '<description>'

    Examples:
      | read('classpath:../data/update-data.csv') |

    @id:8 @UpdateNotExistCharacter
    Scenario Outline: Verify error not exist character update (404)
      * def body = read('classpath:../data/update-character.json')
      * header Content-Type = 'application/json'
      Given path 'characters', id_not_found
      And request body
      When method put
      * print body
      Then status 404
      * print response
      And match response.error == 'Character not found'

      Examples:
        | read('classpath:../data/update-data.csv') |

    @id:9 @DeleteCharacter
    Scenario: Verify character delete (200)
      Given path 'characters', id_character
      When method delete
      Then status 204

    @id:10 @DeleteNotExistCharacter
    Scenario: Verify character delete not exist error (404)
      Given path 'characters', id_character
      When method delete
      Then status 404