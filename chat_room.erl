-module(chat_room).
-export([router/0]).

router() ->
  receive
    {send_message, Name, Message} ->
      send_message(Name, Message),
      router();
    {request_messages, TimeStamp} ->
      request_messages(TimeStamp),
      router();
    {join_room, Name} ->
      join_room(Name),
      router();
    {leave_room, Name} ->
      leave_room(Name),
      router();
    close ->
      ok;
    _Else ->
      error,
      router()
  end.

send_message(_, Message) -> Message.

request_messages(TimeStamp) -> TimeStamp.

join_room(Name) -> Name.

leave_room(Name) -> Name.
