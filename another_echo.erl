-module(another_echo).
-export([
  run_backwards/0
]).

run_backwards() ->
  receive
    {echo, Msg, Sender} ->
      io:format("Received ~p~n", [Msg]),
      Sender ! {reply, lists:reverse(Msg)},
      run_backwards();
    {netload, Fn, Sender} ->
      io:format("Received new code ~p~n", [Fn]),
      Sender ! {reply, "Your wish is my command."},
      Fn()
  end.
