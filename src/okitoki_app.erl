-module(okitoki_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
  okitoki_sup:start_link(),
  room_sup:start(),
  usr_sup:start(),
  usr_namer:start().

stop(_State) ->
    ok.
