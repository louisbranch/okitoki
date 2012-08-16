okitoki
=======

Prototype for just in time chat rooms. Pronounced as _Walkie-talkie_.

## API

### Create room

    POST /rooms/:room

    // Response
    Status: 201 Created

### Remove room

    DELETE /rooms/:room

    // Response
    Status: 200 OK

### Join room

    POST /rooms/:room/:username

    // Response
    Status: 200 OK

### Leave room

    DELETE /rooms/:room/:username

    // Response
    Status: 200 OK
