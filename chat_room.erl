%TODO create database
-module(chat_room).
-export([router/0]).

router() ->
  receive
    {send_message, Username, Message} ->
      send_message(Username, Message),
      router();
    {request_messages, TimeStamp} ->
      request_messages(TimeStamp),
      router();
    {join_room, Username} ->
      join_room(Username),
      router();
    {leave_room, Username} ->
      leave_room(Username),
      router();
    close ->
      ok;
    _Else ->
      error,
      router()
  end.

send_message(_, Message) ->
  %TODO save user, message and timestamp
  Message.

request_messages(TimeStamp) ->
  %TODO request messages after given timestamp
  %or all with none is given
  TimeStamp.

join_room(Username) ->
  %TODO add username to database
  Username.

leave_room(Username) ->
  %TODO remove username from database
  Username.
