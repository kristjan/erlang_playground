-module(day_1).
-export([
  count_words/1,
  count_to_ten/0,
  check/1
]).
-import(string, [
  substr/2,
  chr/2
]).

count_words("") -> 0;
count_words(String) ->
  Space = chr(String, $ ),
  if
    Space == 0 -> 1;
    true -> 1 + count_words(substr(String, Space + 1))
  end.

count_to(1) -> io:format("~w~n", [1]);
count_to(N) ->
  count_to(N - 1),
  io:format("~w~n", [N]).
count_to_ten() -> count_to(10).

check(success) -> io:format("success~n", []);
check({error, Message}) -> io:format("error: ~s~n", [Message]).

