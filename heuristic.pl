% TODO: Clean some rules from unnecessary checks (e.g., no_surrounding_pit() checks if there is room(X,Y) which adjacent() also does that)

:- abolish(stench/1).
:- abolish(breeze/1).
:- abolish(glitter/1).
:- abolish(scream/1).
:- abolish(safe/1).
:- abolish(visited/2).
:- abolish(has_wumpus/2).
:- abolish(has_pit/2).
:- abolish(current_safest_cell/1).

:- dynamic([
  stench/1,
  breeze/1,
  glitter/1,
  scream/1,
  gold/1,
  safe/1,
  visited/2,
  has_wumpus/1,
  has_pit/1,
  has_no_pit/1,
  has_no_wumpus/1,
  current_safest_cell/1,
  explorable/1,
  maybe_has_pit/1,
  maybe_has_wumpus/1
]).

no_surrounding_pit(room(A,B)) :- adjacent(room(X,Y), room(A, B)), (not(has_pit(room(X, Y), _)); has_pit(room(X, Y), yes); has_pit(room(X, Y), maybe)).

no_surrounding_wumpus(room(A,B)) :- adjacent(room(X,Y), room(A, B)), not(has_wumpus(room(X,Y), no)) , !, fail.

all_adjacent_visited(room(A,B)) :- adjacent(room(X,Y), room(A, B)), not(visited(room(X,Y), _)) , !, fail.

% An adjacent room(X,Y) has no pit if it is adjacent to a room that has no breeze, or if it has a wumpus
has_no_pit(room(X,Y)) :- (position(room(A, B), _), not(breeze(room(A,B))); has_wumpus(room(X,Y))), retractall(maybe_has_pit(room(X,Y))), assertz(has_no_pit(room(X,Y))).

% An adjacent room(X,Y) has no wumpus if it is adjacent to a room that has no stench, or if it has a pit
has_no_wumpus(room(X,Y)) :- (position(room(A, B), _), not(stench(room(A,B))); has_pit(room(X,Y))), retractall(maybe_has_wumpus(room(X,Y))), assertz(has_no_wumpus(room(X,Y))).

% An adjacent room(X,Y) does have a pit if ....
has_pit(room(X,Y)) :- (not(has_no_pit(room(X, Y))), breeze(room(A,B)), adjacent(room(X,Y), room(A, B)), (no_surrounding_pit(room(A,B)); all_adjacent_visited(room(A,B)))), retractall(maybe_has_pit(room(X,Y))), assertz(has_pit(room(X,Y))).

% An adjacent room(X,Y) does have a wumpus if ....
has_wumpus(room(X,Y)) :- (not(has_no_wumpus(room(X, Y))), stench(room(A,B)), adjacent(room(X,Y), room(A, B)), (no_surrounding_wumpus(room(A,B)); all_adjacent_visited(room(A,B)))), retractall(maybe_has_wumpus(room(X,Y))), assertz(has_wumpus(room(X,Y))).

maybe_has_pit(room(X,Y)) :- not(has_pit(room(X, Y))), not(has_no_pit(room(X, Y))), not(has_wumpus(room(X,Y))), not(has_no_wumpus(room(X,Y))),
                            adjacent(room(X,Y), room(A, B)) , stench(room(A,B)), !.

maybe_has_wumpus(room(X,Y)) :- not(has_wumpus(room(X, Y))), not(has_no_wumpus(room(X, Y))), not(has_pit(room(X,Y))), not(has_no_pit(room(X,Y))),
                               adjacent(room(X,Y), room(A, B)) , stench(room(A,B)), !.

tell_kb([yes, _, _, _], room(X,Y)) :- retractall(stench(room(X, Y))), assertz(stench(room(X,Y))).
tell_kb([_, yes, _, _], room(X,Y)) :- retractall(breeze(room(X, Y))), assertz(breeze(room(X,Y))).
tell_kb([_, _, yes, _], room(X,Y)) :- retractall(glitter(room(X, Y))), assertz(glitter(room(X,Y))).
tell_kb([_, _, _, yes], _) :- assertz(scream(yes)).
tell_kb([no,no,no,no], _).

% HEURISTICS

heuristic([_, _, _, yes]) :- write('h1'), nl, write('Congrats... You won!').

heuristic([no, no, _, _]) :- write('heuNoNo'), nl, findall(room(C,D), explorable(room(C,D)), [H|_]), position(room(X, Y), T), travel(room(X, Y), H, T), !.

heuristic([yes, _, _, _]) :- write('h2'), nl, position(room(X, Y), T), adjacent(room(X, Y), room(A, B)),
                             has_wumpus(room(A,B)), !, shoot(room(A, B), T).

heuristic([yes, _, _, _]) :- write('h3'), nl, position(room(X, Y), T), findall(room(A,B), explorable(room(C,D)), [H|_]), travel(room(X, Y), H, T), !.

heuristic([_, yes, _, _]) :- write('h3'), nl, position(room(X, Y), T), findall(room(A,B), explorable(room(A,B)), [H|_]),
                             travel(room(X, Y), H, T), !.

heuristic([no, _, _, _]) :- write('h4'), position(room(X, Y), T), adjacent(room(A, B), room(X, Y)),
                            retractall(maybe_has_wumpus(room(A, B))),
                            asserta(has_no_wumpus(room(A, B))).

heuristic([_, no, _, _]) :- position(room(X, Y), T), adjacent(room(A, B), room(X, Y)),
                            retractall(maybe_has_pit(room(A, B))),
                            asserta(has_no_pit(room(A, B))).

/*heuristic([yes, _, _, _]) :- position(room(X, Y), T), adjacent(room(A, B), room(X, Y)),
                            room(A, B) \== room(1, 1),
                            not(has_pit(room(A, B), yes)),
                            not(has_pit(room(A, B), no)),
                            not(has_wumpus(room(A, B), yes)),
                            not(has_wumpus(room(A, B), no)),
                            not(has_wumpus(room(A, B), maybe)), % to avoid redundancy
                            asserta(has_wumpus(room(A, B), maybe)).*/

% the next 2 rules are almost identical
/*heuristic([yes, _, _, _]) :- write('h2'), nl, position(room(X, Y), T), tell_kb(stench, room(X, Y)), adjacent(room(X, Y), room(A, B)),
                                          has_wumpus(room(A,B), yes), !, shoot(room(A, B), T).*/

% The order of the next 2 predicates is tricky. This way, we never shoot randomly.
% The other way, we always shoot randomly.
% I want to determine when to shoot randomly. In other words, when is the current safest cell not good enough?

% If not sure where the wumpus is, and no adjacent room is maybe safe, shoot any random adjacent room where there may be the wumpus
/*heuristic([yes, _, _, _]) :- write('h4'), nl, position(room(X, Y), T), tell_kb(stench, room(X, Y)), adjacent(room(X, Y), room(A, B)),
                                                 has_wumpus(room(A,B), maybe), !, shoot(room(A, B), T).*/

% If not sure where the wumpus is, move to the safest explorable room
/*heuristic([yes, _, _, _]) :- write('h3'), nl, position(room(X, Y), T), tell_kb(stench, room(X, Y)), current_safest_cell(room(A, B)),
                                          travel(room(X, Y), room(A, B), T), !.*/



/*heuristic([_, yes, _, _]) :- write('h6'), nl, position(room(X, Y), T), tell_kb(breeze, room(X, Y)),
                            adjacent(room(X, Y), room(A, B)),
                            room(A, B) \== room(1, 1),
                            not(has_pit(room(A, B), yes)),
                            not(has_pit(room(A, B), no)),
                            not(has_wumpus(room(A, B), yes)),
                            not(has_wumpus(room(A, B), no)),
                            retractall(has_pit(room(A, B), maybe)),
                            asserta(has_pit(room(A, B), maybe)).

heuristic([_, yes, _, _]) :- write('h6b'), nl, current_safest_cell(room(C, D)), position(room(X, Y), T),
                            format("travel from room(~w,~w) to room(~w,~w) ~n", [X, Y, C, D]), travel(room(X, Y), room(C, D), T).

heuristic([_, _, yes, _]) :- write('h7'), nl, position(room(X, Y), _), tell_kb(glitter, room(X, Y)), grab_gold(), !.

explorableRooms(L) :- position(room(X,Y), _),
                      findall(room(A,B), adjacent(room(X, Y), room(A, B)), L1),
                      findall(room(C,D), visited(room(C,D),_), L2),
                      findall(L3, adjacent_to_visited(L3) ,L4),
                      flatten(L4, L5),
                      append([L1, L2, L5], R),
                      remove_duplicates(R, L). */

% This keeps track of all explorable rooms from any position
add_explorable() :- (position(room(X,Y), _), adjacent(room(X, Y), room(A, B)), not(visited(room(A,B), _)), has_no_pit(room(A,B)), has_no_wumpus(room(A,B)), assertz(explorable(room(A,B)))); true.

adjacent_to_visited(L) :- visited(room(X,Y), _), findall(room(A,B), adjacent(room(X, Y), room(A, B)), L).

remove_duplicates([], []).
remove_duplicates([Head | Tail], Result) :-
    member(Head, Tail), !,
    remove_duplicates(Tail, Result).
remove_duplicates([Head | Tail], [Head | Result]) :-
    remove_duplicates(Tail, Result).

current_safest_cell(room(X, Y)) :- findall(S, total_current_score(room(_, _), S), L),
                                  min_list(L, MinScore),
                                  min_score_room(MinScore, room(X, Y)),
                                  position(room(A, B), T),
                                  room(A, B) \== room(X, Y), !.

min_score_room(MinVal, room(X, Y)) :- total_current_score(room(X, Y), MinVal).

total_current_score(room(X, Y), S) :- safe(room(X, Y)), S is 0.
total_current_score(room(X, Y), S) :- findall(P, partial_score(room(X, Y), P), L), sum_list(L, S).

partial_score(room(X, Y), S) :- explorableRooms(E), member(room(X, Y), E), has_pit(room(X, Y), yes), S is 2000.
partial_score(room(X, Y), S) :- explorableRooms(E), member(room(X, Y), E), has_wumpus(room(X, Y), yes), S is 2000.
partial_score(room(X, Y), S) :- explorableRooms(E), member(room(X, Y), E), has_pit(room(X, Y), maybe), S is 500.
partial_score(room(X, Y), S) :- explorableRooms(E), member(room(X, Y), E), has_wumpus(room(X, Y), maybe), S is 900.
partial_score(room(X, Y), Def) :- Def is 0.
