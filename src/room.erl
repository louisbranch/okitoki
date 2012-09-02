-module(room).
-export([start/1]).
-export([router/1]).

% Starts a new chat room process
% and term storage for usernames
start(Room) ->
  Pid = spawn(room, router, [Room]),
  ets:new(Room, [bag, named_table]),
  ets:give_away(Room, Pid, []),
  register(Room, Pid),
  Pid.

router(Room) ->
  receive
    {send_message, SenderPid, Username, Message} ->
      send_message(SenderPid, Room, Username, Message),
      router(Room);
    {join_room, UserPid} ->
      ets:insert(Room, {UserPid}),
      router(Room);
    {leave_room, UserPid} ->
      ets:delete(Room, UserPid),
      router(Room);
    close ->
      ok;
    _Else ->
      %% log error
      error,
      router(Room)
  end.

send_message(SenderPid, Room, Username, Message) ->
  MsgParams = {chat_message, Room, Username, Message},
  ets:foldl(
    fun({TargetPid}, _Acc) ->
        broadcast(TargetPid, SenderPid, MsgParams) end,
    notused, Room).

broadcast(TargetPid, SenderPid, MsgParams)
  when TargetPid =/= SenderPid ->
  TargetPid ! MsgParams;
broadcast(_TargetPid, _SenderPid, _MsgParams) -> ok.
