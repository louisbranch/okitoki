-module(chat_room).
-export([start/1,request_messages/1]).
-export([router/1]).

% Starts a new chat room process
start(Room) ->
  spawn(chat_room, router, [Room]).

% Should this function be here?
request_messages(Room) ->
  %TODO request all room messages
  io:format("~s ~n", [Room]).

router(Room) ->
  receive
    {send_message, Username, Message} ->
      send_message(Username, Message),
      router(Room);
    {join_room, Username} ->
      join_room(Username),
      router(Room);
    {leave_room, Username} ->
      leave_room(Username),
      router(Room);
    close ->
      ok;
    _Else ->
      error,
      router(Room)
  end.

send_message(Username, Message) ->
  %TODO save user, message and timestamp
  io:format("~s says: ~p~n", [Username, Message]).

join_room(Username) ->
  %TODO add username to database
  io:format("~s has joined~n", [Username]).

leave_room(Username) ->
  %TODO remove username from database
  io:format("~s has left~n", [Username]).
