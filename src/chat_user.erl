-module(chat_user).
-export([start/1]).
-export([loop/1]).

start(Username) ->
  spawn(chat_user, loop, [Username]).

loop(Username) ->
  receive
    {chat_message, Room, SenderName, Message} ->
      io:format("~s received ~p from ~s @~s~n", [Username, Message, SenderName, Room]);
    _Else ->
      io:format("Error: ~p~n", [_Else])
  end,
  loop(Username).
