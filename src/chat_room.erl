-module(chat_room).
-export([start/1,request_messages/1]).
-export([router/1]).

% Starts a new chat room process
% and term storage for usernames
start(Room) ->
  Pid = spawn(chat_room, router, [Room]),
  ets:new(Room, [bag, named_table]),
  ets:give_away(Room, Pid, []),
  Pid.

% Should this function be here?
request_messages(Room) ->
  %TODO request all room messages
  io:format("~s ~n", [Room]).

router(Room) ->
  receive
    {send_message, Username, Message} ->
      send_message(Room, Username, Message),
      router(Room);
    {join_room, Username} ->
      join_room(Room, Username),
      router(Room);
    {leave_room, Username} ->
      leave_room(Room, Username),
      router(Room);
    close ->
      ok;
    _Else ->
      error,
      router(Room)
  end.

send_message(Room, Username, Message) ->
  chat_db:create_message(Room, Username, Message).

join_room(Room, Username) ->
  ets:insert(Room, {Username}).

leave_room(Room, Username) ->
  ets:delete(Room, Username).
