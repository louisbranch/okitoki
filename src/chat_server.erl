-module(chat_server).
-export([start/0]).
-export([init/0]).

% Move start process to a chat supervisor
% give away the table to server and set itself
% as the tabler heir
% In the case of crash, start again?
start() ->
  Pid = spawn(chat_server, init, []),
  register(chat_server, Pid),
  ets:new(rooms, [set, named_table]),
  ets:give_away(rooms, Pid, []).

init() ->
  receive
    {open_room, Room} ->
      open_room(Room),
      init();
    {close_room, Room} ->
      close_room(Room),
      init();
    {send_to_room, Room, Params} ->
      send_to_room(Room, Params),
      init();
    close ->
      ok;
    _Else ->
      %save message to log file
      io:format("~p~n", [_Else]),
      init()
  end.

open_room(Room) ->
  Result = ets:lookup(rooms, Room),
  case Result of
    [_] ->
      io:format("~s room already exist~n", [Room]),
      error;
    [] ->
      Pid = chat_room:start(Room),
      ets:insert(rooms, {Room, Pid}),
      io:format("~s room was opened~n", [Room]),
      ok
    end.

close_room(Room) ->
  Result = ets:lookup(rooms, Room),
  case Result of
    [{Room, RoomPid}] ->
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
    [{Room, RoomPid}] ->
      RoomPid ! Params,
      ok;
    [] ->
      io:format("~s room doesn't exist~n", [Room]),
      error
    end.
