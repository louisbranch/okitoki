-module(usr_sup).
-export([start/0,stop/0]).
-export([loop/0]).

start() ->
  Pid = spawn(usr_sup, loop, []),
  register(usr_sup, Pid).

stop() ->
  exit(whereis(usr_sup), normal),
  unregister(usr_sup).

loop() ->
  receive
    {new_user, SenderPid} ->
      UserPid = new(),
      SenderPid ! {user_created, UserPid};
    {new_user, SenderPid, Username} ->
      {UserPid, UsernameStatus} = new(Username),
      SenderPid ! {user_created, UserPid, UsernameStatus};
    {'DOWN', Ref, process, Pid, Reason} ->
      demonitor(Ref),
      usr_namer ! {delete_username, Pid},
      io:format("Process ~p has exited: ~p~n", [Pid,Reason]);
    _Else ->
      io:format("Error: ~p~n", [_Else])
  end,
  loop().

new() ->
  Pid = usr:start(anonymous),
  monitor(process, Pid),
  Pid.

new(Username) ->
  Pid = new(),
  usr_namer ! {insert_username, self(), Username, Pid},
  receive
    ok ->
      Pid ! {set_username, Username},
      {Pid, ok};
    error ->
      {Pid, error}
  end.
