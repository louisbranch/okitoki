-module(chat_user).
-export([new/0,new/1]).
-export([loop/1]).

new() -> start(anonymous).
new(Username) -> start(Username).

start(Username) ->
  spawn(chat_user, loop, [Username]).

loop(Username) ->
  receive
    {chat_message, Room, SenderName, Message} ->
      io:format("~s received ~p from ~s @~s~n", [Username, Message, SenderName, Room]),
      loop(Username);
    {change_username, Username} ->
      ok,
      loop(Username);
    {change_username, NewUsername} ->
      change_username(Username, NewUsername),
      loop(Username);
    stop ->
      ok;
    _Else ->
      io:format("Error: ~p~n", [_Else]),
      loop(Username)
  end.

change_username(OldUsername, NewUsername) ->
  ok.
