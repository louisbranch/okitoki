-module(usr_namer).
-export([start/0,stop/0]).
-export([loop/0]).

start() ->
  Pid = spawn(usr_namer, loop, []),
  ets:new(usernames, [set, named_table, public]),
  register(usr_namer, Pid).

stop() ->
  exit(whereis(usr_namer), normal),
  unregister(usr_namer).

loop() ->
  receive
    {insert_username, SenderPid, Username, UserPid} ->
      SenderPid ! insert_username(Username, UserPid);
    {delete_username, Pid} ->
      delete_username(Pid);
    {get_username, SenderPid, Pid} ->
      get_username(SenderPid, Pid)
  end,
  loop().

insert_username(Username, Pid) ->
  Result = ets:lookup(usernames, Username),
  case Result of
    [{Username, _Pid}] ->
      error;
    [] ->
      ets:insert(usernames, {Username, Pid}),
      ok
  end.

delete_username(Pid) ->
  ets:match_delete(usernames, {'_', Pid}).

get_username(SenderPid, Pid) ->
  Result = ets:match_object(usernames, {'$1', Pid}),
  case Result of
    [{Username, Pid}] ->
      SenderPid ! {username, Username};
    [] ->
      error
  end.
