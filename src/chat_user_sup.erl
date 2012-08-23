-module(chat_user_sup).
-export([start/0,stop/0,new/0,new/1]).
-export([loop/0]).

start() ->
  Pid = spawn(chat_user_sup, loop, []),
  ets:new(usernames, [set, named_table]),
  register(chat_user_sup, Pid).

stop() ->
  exit(whereis(chat_user_sup), normal),
  unregister(chat_user_sup).

loop() ->
  receive
    {'DOWN', Ref, process, Pid, Reason} ->
      demonitor(Ref),
      delete_username(Pid),
      io:format("Process ~p has exited: ~p~n", [Pid,Reason]);
    _Else ->
      io:format("Error: ~p~n", [_Else])
  end,
  loop().

%% Move from this to bottom to a username creator

new() ->
  Pid = chat_user:start(anonymous),
  monitor(process, Pid).

new(Username) ->
  Pid = chat_user:start(anonymous),
  monitor(process, Pid),
  case insert_username(Username, Pid) of
    ok -> Pid ! {set_username, Username};
    error -> error
  end.

insert_username(Username, Pid) ->
  Result = ets:lookup(usernames, Username),
  case Result of
    [{Username, _Pid}] ->
      error;
    [] ->
      ets:insert(usernames, {Username, Pid }),
      ok
  end.

delete_username(Pid) ->
  ets:match_delete(usernames, {'_', Pid}).
