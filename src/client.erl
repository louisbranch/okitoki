-module(client).
-export([open_room/1, close_room/1, new_user/0, new_user/1, join_room/2, leave_room/2, send_message/3]).

open_room(Name) ->
  room_sup ! {open_room, self(), Name}.

close_room(Name) ->
  Name ! close.

new_user() ->
  usr_sup ! {new_user, self()},
  receive
    {user_created, ok, Pid} ->
      {ok, Pid}
  end.

new_user(Name) ->
  usr_sup ! {new_user, self(), Name},
  receive
    {user_created, ok, Pid} ->
      {ok, Pid};
    {user_created, error, Pid} ->
      {"username already in use", Pid}
  end.

join_room(UserPid, Room) ->
  case whereis(Room) of
    undefined ->
      error;
    _Pid ->
      Room ! {join_room, UserPid}
  end.

leave_room(UserPid, Room) ->
  Room ! {leave_room, UserPid}.

send_message(UserPid, Room, Message) ->
  %% TODO search for username
  Username = name,
  Room ! {send_message, UserPid, Username, Message}.
