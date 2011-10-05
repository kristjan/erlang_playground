-module(echo).
-export([
  echo/2,
  shout/2,
  swap/1,
  netload/2,

  start/0,
  run/0,
  run_louder/0
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
      run();
    {swap, Sender} ->
      io:format("Received swap signal~n", []),
      Sender ! {reply, "Swapping in new code."},
      ?MODULE:run();
    {netload, Fn, Sender} ->
      io:format("Received new code ~p~n", [Fn]),
      Sender ! {reply, "Your wish is my command."},
      Fn()
  end.

run_louder() ->
  receive
    {shout, Msg, Sender} ->
      io:format("Received ~p~n", [Msg]),
      Sender ! {reply, string:to_upper(Msg)},
      run_louder();
    {netload, Fn, Sender} ->
      io:format("Received new code ~p~n", [Fn]),
      Sender ! {reply, "Your wish is my command."},
      Fn()
  end.

echo(Msg, Server) ->
  {echo, Server} ! {echo, Msg, self()},
  print_reply().

shout(Msg, Server) ->
  {echo, Server} ! {shout, Msg, self()},
  print_reply().

swap(Server) ->
  {echo, Server} ! {swap, self()},
  print_reply().

netload(Fn, Server) ->
  {echo, Server} ! {netload, Fn, self()},
  print_reply().

print_reply() ->
  receive
    {reply, Reply} ->
      io:format("~p~n", [Reply])
  end.



% == Server ==
%  $ erl -name echoserver
%  > c(echo).          % For echo:start/0
%  > echo:start().

% == Client ==
%  $ erl -name echoclient # Name appears necessary for network communication
%  > net_adm:world().  % Looks at ~/.hosts.erlang for resolution.
%                      % That file should contain `hostname`
%  > c(echo).          % For echo:echo/2
%  > echo:echo("Hi", echoserver@<host>).
%  > echo:swap(echoserver@<host>).
%  > echo:netload(fun echo:run_louder/0, echoserver@<host>).
%  > echo:shout("Hi", echoserver@<host>).
