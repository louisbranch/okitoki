-module(chat_server).
-export([start/0]).
-export([init/1]).

start() ->
  Rooms = dict:new(),
  spawn(chat_server, init, [Rooms]).

init(Rooms) ->
  receive
    {open_room, RoomName} ->
      NewRooms = open_room(RoomName, Rooms),
      init(NewRooms);
    {close_room, RoomName} ->
      NewRooms = close_room(RoomName, Rooms),
      init(NewRooms);
    {send_to_room, RoomName, Params} ->
      send_to_room(RoomName, Rooms, Params),
      init(Rooms);
    _Else ->
      %save message to log file
      init(Rooms)
  end.

open_room(RoomName, Rooms) ->
  ExistingRoom = dict:is_key(RoomName, Rooms),
  case ExistingRoom of
    false ->
      Pid = spawn(chat_room, router, []),
      io:format("~s room was opened~n", [RoomName]),
      dict:append(RoomName, Pid, Rooms);
    true ->
      io:format("~s room already exist~n", [RoomName]),
      Rooms
    end.

close_room(RoomName, Rooms) ->
  Result = dict:find(RoomName, Rooms),
  case Result of
    {ok, [RoomPid|_]} ->
      RoomPid ! close,
      NewRooms = dict:erase(RoomName, Rooms),
      io:format("~s room was closed~n", [RoomName]),
      NewRooms;
    error ->
      io:format("~s room doesn't exist~n", [RoomName]),
      Rooms
    end.

send_to_room(RoomName, Rooms, Params) ->
  Result = dict:find(RoomName, Rooms),
  case Result of
    {ok, [RoomPid|_]} ->
      RoomPid ! Params,
      ok;
    error ->
      io:format("~s room doesn't exist~n", [RoomName]),
      error
    end.
