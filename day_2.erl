-module(day_2).
-export([
  value_for/2,
  item_totals/1,
  tictactoe/1
]).

value_for([], _Key) -> null;
value_for([{Key, Value} | _Tail], Key) -> Value;
value_for([_Head | Tail], Key) -> value_for(Tail, Key).

item_totals(Cart) ->
  [{Item, Quantity * Price} || {Item, Quantity, Price} <- Cart].

tictactoe({{P, P, P}, _, _}) -> P;
tictactoe({_, {P, P, P}, _}) -> P;
tictactoe({_, _, {P, P, P}}) -> P;
tictactoe({{P, _, _}, {P, _, _}, {P, _, _}}) -> P;
tictactoe({{_, P, _}, {_, P, _}, {_, P, _}}) -> P;
tictactoe({{_, _, P}, {_, _, P}, {_, _, P}}) -> P;
tictactoe({{P, _, _}, {_, P, _}, {_, _, P}}) -> P;
tictactoe({{_, _, P}, {_, P, _}, {P, _, _}}) -> P;
tictactoe({{A1, A2, A3}, {B1, B2, B3}, {C1, C2, C3}}) ->
  Played = fun(P) -> (P == x) or (P == o) end,
  AllPlayed = lists:all(Played, [A1, A2, A3, B1, B2, B3, C1, C2, C3]),
  case AllPlayed of
    true -> cat;
    false -> no_winner
  end.
