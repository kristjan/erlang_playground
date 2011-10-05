-module(echo).
-export([
  echo/2,
  start/0,
  run/0
]).
-define(GREETING, "You said ").

start() ->
  register(echo, spawn(echo, run, [])),
  io:format("Started echo server~n", []).

run() ->
  receive
    {echo, Msg, Sender} ->
      io:format("Received ~p~n", [Msg]),
      Sender ! {reply, string:concat(?GREETING, Msg)},
      run()
  end.

echo(Msg, Server) ->
  {echo, Server} ! {echo, Msg, self()},
  receive
    {reply, Reply} ->
      io:format("~p~n", [Reply])
  end.


% == Server ==
%   $ erl -name echoserver
%   > c(echo).          % For echo:start/0
%   > echo:start().

% == Client ==
%   $ erl -name echoclient # Name appears necessary for network communication
%   > net_adm:world().  % Looks at ~/.hosts.erlang for resolution.
%                       % That file should contain `hostname`
%   > c(echo).          % For echo:echo/2
%   > echo:echo("Hi", echoserver@<host>).
