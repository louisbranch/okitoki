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
    {open_room, RoomName} ->
      open_room(RoomName);
    {close_room, RoomName} ->
      close_room(RoomName);
    {send_to_room, RoomName, Params} ->
      send_to_room(RoomName, Params);
    _Else ->
      %save message to log file
      io:format("~p~n", [_Else])
  end,
  init().

open_room(RoomName) ->
  Result = ets:lookup(rooms, RoomName),
  case Result of
    [_] ->
      io:format("~s room already exist~n", [RoomName]),
      error;
    [] ->
      Pid = chat_room:start(),
      ets:insert(rooms, {RoomName, Pid}),
      io:format("~s room was opened~n", [RoomName]),
      ok
    end.

close_room(RoomName) ->
  Result = ets:lookup(rooms, RoomName),
  case Result of
    [{_, RoomPid}] ->
      RoomPid ! close,
      ets:delete(rooms, RoomName),
      io:format("~s room was closed~n", [RoomName]),
      ok;
    [] ->
      io:format("~s room doesn't exist~n", [RoomName]),
      error
    end.

send_to_room(RoomName, Params) ->
  Result = ets:lookup(rooms, RoomName),
  case Result of
    [{_, RoomPid}] ->
      RoomPid ! Params,
      ok;
    [] ->
      io:format("~s room doesn't exist~n", [RoomName]),
      error
    end.
