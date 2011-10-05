-module(sort).
-export([
  insertion/1,
  merge/1,
  quick/1,
  selection/1
]).

insertion([]) -> [];
insertion([Item | List]) -> insertion(List, [Item]).
insertion([], Sorted) -> Sorted;
insertion([Item | List], Sorted) ->
  insertion(List,
    [X || X <- Sorted, X =< Item]
    ++ [Item] ++
    [X || X <- Sorted, X > Item]).


merge([]) -> [];
merge([E]) -> [E];
merge(List) ->
  {Beginning, End} = lists:split(erlang:trunc(length(List) / 2), List),
  weave(merge(Beginning), merge(End)).

weave(List, []) -> List;
weave([], List) -> List;
weave([One | OneTail], [Two | TwoTail]) ->
  if
    One =< Two -> [One] ++ weave(OneTail, [Two | TwoTail]);
    Two < One -> [Two] ++ weave([One | OneTail], TwoTail)
  end.


quick([]) -> [];
quick([Pivot | Tail]) ->
  quick([X || X <- Tail, X =< Pivot])
  ++ [Pivot] ++
  quick([X || X <- Tail, X > Pivot]).


selection([]) -> [];
selection(List) ->
  Min = min(List),
  [Min | selection(delete(Min, List))].

min([Item]) -> Item;
min([Head | Tail]) ->
  Other = min(Tail),
  if
    Head < Other -> Head;
    true -> Other
  end.

delete(_Item, []) -> [];
delete(Item, [Item | Tail]) -> Tail;
delete(Item, [Head | Tail]) -> [Head] ++ delete(Item, Tail).

