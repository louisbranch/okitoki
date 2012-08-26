-module(usr).
-export([start/1]).
-export([loop/1]).

start(Username) ->
  spawn(usr, loop, [Username]).

loop(Username) ->
  receive
    {chat_message, Room, SenderName, Message} ->
      io:format("~s received ~p from ~s @~s~n", [Username, Message, SenderName, Room]),
      loop(Username);
    {set_username, NewUsername} ->
      loop(NewUsername);
    {change_username, Username} ->
      ok,
      loop(Username);
    {change_username, NewUsername} ->
      usr_sup:change_username(Username, NewUsername),
      loop(Username);
    stop ->
      ok;
    _Else ->
      io:format("Error: ~p~n", [_Else]),
      loop(Username)
  end.
