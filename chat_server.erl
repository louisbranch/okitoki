-module(chat_server).
-export([start/0]).
-export([init/0]).

start() ->
  Server = spawn(chat_server, init, []),
  Server ! create_rooms_db,
  register(chat_server, Server).

init() ->
  receive
    create_rooms_db ->
      ets:new(rooms, [set, named_table]);
    {open_room, Room} ->
      open_room(Room);
    {close_room, Room} ->
      close_room(Room);
    {send_to_room, Room, Params} ->
      send_to_room(Room, Params);
    _Else ->
      %save message to log file
      io:format("~p~n", [_Else])
  end,
  init().

open_room(Room) ->
  Result = ets:lookup(rooms, Room),
  case Result of
    [_] ->
      io:format("~s room already exist~n", [Room]),
      error;
    [] ->
      Pid = chat_room:start(),
      ets:insert(rooms, {Room, Pid}),
      io:format("~s room was opened~n", [Room]),
      ok
    end.

close_room(Room) ->
  Result = ets:lookup(rooms, Room),
  case Result of
    [{_, RoomPid}] ->
      RoomPid ! close,
      ets:delete(rooms, Room),
      io:format("~s room was closed~n", [Room]),
      ok;
    [] ->
      io:format("~s room doesn't exist~n", [Room]),
      error
    end.

send_to_room(Room, Params) ->
  Result = ets:lookup(rooms, Room),
  case Result of
    [{_, RoomPid}] ->
      RoomPid ! Params,
      ok;
    [] ->
      io:format("~s room doesn't exist~n", [Room]),
      error
    end.
