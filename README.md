okitoki
=======

Prototype for just in time chat rooms. Pronounced as _Walkie-talkie_.

## Future API

### Create room

    POST /api/v1/rooms

    // Body
    {"name" : "foo"}

    // Response
    Status: 201 Created

### Remove room

    DELETE /api/v1/rooms/:room_name

    // Response
    Status: 200 OK

### Create user

    POST /api/v1/users

    // Body
    {"name" : "Mr Anderson"}

    // Response
    Status: 201 Created
    {"userKey" : "bar"}

### Join room

    POST /api/v1/rooms/:room_name/users

    // Body
    {"userKey" : "bar"}

    // Response
    Status: 200 OK

### Leave room

    DELETE /api/v1/rooms/:room_name/users/:userKey

    // Response
    Status: 200 OK

### Send message

    POST /api/v1/rooms/:room_name/users/:userKey/messages

    // Body
    {"message" : "Hello World!"}

    // Response
    Status: 201 Created

### Get ALL messages

    GET /api/v1/rooms/:room_name/messages

    // Response
    Status: 200 OK
    [
      {
        "name" : "Mr Anderson",
        "body" : "Hello World",
        "createdAt" : "2012-08-25T20:57:53-07:00"
      },
      ...
    ]

### Get NEW messages for user

    GET /api/v1/rooms/:room_name/users/:userKey/messages

    // Response
    Status: 200 OK
    [
      {
        "name" : "Mr Anderson",
        "body" : "Hello World",
        "createdAt" : "2012-08-25T20:57:53-07:00"
      },
      ...
    ]

## Todo

* Build the REST interface
* Build using OTP framework
* Versionate the API
