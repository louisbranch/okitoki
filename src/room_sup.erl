-module(room_sup).
-export([start/0,stop/0]).
-export([loop/0]).

start() ->
  Pid = spawn(room_sup, loop, []),
  register(room_sup, Pid).

stop() ->
  exit(whereis(room_sup), normal),
  unregister(room_sup).

loop() ->
  receive
    {open_room, Pid, Room} ->
      Pid ! open_room(Room);
    {close_room, Pid, Room} ->
      Pid ! close_room(Room);
    {'DOWN', Ref, process, Pid, Reason} ->
      demonitor(Ref),
      io:format("Process ~p has exited: ~p~n", [Pid,Reason]);
    _Else ->
      %save message to log file
      io:format("~p~n", [_Else])
  end,
  loop().

open_room(Room) ->
  case whereis(Room) of
    undefined ->
      Pid = room:start(Room),
      monitor(process, Pid),
      ok;
    _Pid ->
      error
    end.

close_room(Room) ->
  case whereis(Room) of
    undefined ->
      error;
    Pid ->
      Pid ! close
    end.
