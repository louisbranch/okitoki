-module(user_sup).
-export([start/0,stop/0]).
-export([loop/0]).

start() ->
  Pid = spawn(user_sup, loop, []),
  register(user_sup, Pid).

stop() ->
  exit(whereis(user_sup), normal),
  unregister(user_sup).

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
      user_namer:delete_username(Pid),
      io:format("Process ~p has exited: ~p~n", [Pid,Reason]);
    _Else ->
      io:format("Error: ~p~n", [_Else])
  end,
  loop().

new() ->
  Pid = user:start(anonymous),
  monitor(process, Pid),
  Pid.

new(Username) ->
  Pid = new(),
  user_namer ! {insert_username, self(), Username, Pid},
  receive
    ok ->
      Pid ! {set_username, Username},
      {Pid, ok};
    error ->
      {Pid, error}
  end.
