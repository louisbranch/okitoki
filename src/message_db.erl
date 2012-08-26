-module(message_db).
-export([start/0]).
-record(okitoki_message, {room, username, message, timestamp}).

start() ->
  mnesia:create_schema([node()]),
  mnesia:start(),
  mnesia:create_table(okitoki_messages, [{attributes, record_info(fields, okitoki_message)}]).
