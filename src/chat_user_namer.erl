-module(chat_user_namer).
-export([start/0,stop/0]).
-export([loop/0]).

start() ->
  Pid = spawn(chat_user_namer, loop, []),
  ets:new(usernames, [set, named_table, public]),
  register(chat_user_namer, Pid).

stop() ->
  exit(whereis(chat_user_namer), normal),
  unregister(chat_user_namer).

loop() ->
  receive
    {insert_username, SenderPid, Username, UserPid} ->
      SenderPid ! insert_username(Username, UserPid);
    {delete_username, Pid} ->
      delete_username(Pid)
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